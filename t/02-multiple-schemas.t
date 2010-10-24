use strict;
use warnings;
use Test::More tests => 7, import => ['!pass'];
use Test::Exception;

use Dancer ':syntax';
use DBI;
use FindBin '$RealBin';

use File::Spec; #FYI, Dancer::path() uses File::Spec and cat
use File::Temp qw/tempdir/;

eval { require DBD::SQLite };
if ($@) {
    plan skip_all => 'DBD::SQLite required to run these tests';
}

my $dir = tempdir(CLEANUP => 1);

my $dbfile1 = File::Spec->catfile($dir, 'test1.db');
my $dbfile2 = File::Spec->catfile($dir, 'test2.db');

set plugins => {
    DBIC => {
        foo => {
            dsn =>  "dbi:SQLite:dbname=$dbfile1",
        },
        bar => {
            dsn =>  "dbi:SQLite:dbname=$dbfile2",
        },
    }
};

unlink $dbfile1, $dbfile2;

my $dbh1 = DBI->connect("dbi:SQLite:dbname=$dbfile1");

ok $dbh1->do(q{
    create table user (name varchar(100) primary key, age int)
}), 'Created sqlite test1 db.';

my @users = ( ['bob', 30] );
for my $user (@users) { $dbh1->do('insert into user values(?,?)', {}, @$user) }

my $dbh2 = DBI->connect("dbi:SQLite:dbname=$dbfile2");

ok $dbh2->do(q{
    create table user (name varchar(100) primary key, age int)
}), 'Created sqlite test2 db.';

@users = ( ['sue', 20] );
for my $user (@users) {
    $dbh2->do(q{ insert into user values(?,?) }, {}, @$user);
}

use lib "$RealBin/../lib";
use Dancer::Plugin::DBIC;

my $user = schema('foo')->resultset('User')->find('bob');
ok $user, 'Found bob.';
is $user->age => '30', 'Bob is getting old.';

$user = schema('bar')->resultset('User')->find('sue');
ok $user, 'Found sue.';
is $user->age => '20', 'Sue is the right age.';

throws_ok { schema('poo')->resultset('User')->find('bob') }
    qr/schema poo is not configured/, 'Missing schema error thrown';

unlink $dbfile1, $dbfile2;
