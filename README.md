# NAME

Dancer::Plugin::Apache::Solr - Apache::Solr interface for Dancer applications

# VERSION

version 0.001

# SYNOPSIS

    use Dancer;
    use Dancer::Plugin::Apache::Solr qw(solr);

    get '/search' => sub {
      my $results = solr('default')->select(q => param 'q');

      # If you are accessing the 'default' schema, then you can just do:
      my $results = solr->select(q => param 'q');

      template search_results => {
        results => do_something_clever_with ($results)
      };
    };

    dance;

# DESCRIPTION

This plugin makes it very easy to create [Dancer](https://metacpan.org/pod/Dancer) applications that interface
with the Apache Solr search engine.

It automatically exports the keyword `solr` which returns an [Apache::Solr](https://metacpan.org/pod/Apache::Solr) object.

You just need to configure your connection information.

For performance, Apache::Solr objects are cached in memory and are lazy loaded the first time they are accessed.

# CONFIGURATION

Configuration can be done in your [Dancer](https://metacpan.org/pod/Dancer) config file.

## Simple example

Here is a simple example. It defines one Solr server named `default`:

    plugins:
      Apache-Solr:
        default:
          server: http://solr.example.com/search/

## Multiple servers

In this example, there are 2 servers configured named `default` and `accessories`:

    plugins:
      Apache-Solr:
        default:
          server: http://solr.example.com/productSearch/
        accessories:
          server: http://solr.example.com/accessorySearch/

Each server configured must at least have a `server` option set.

If you only have one server configured, or one of them is named
`default`, you can call `solr` without an argument to get the only
or `default` server, respectively.

## server\_info

Alternatively, you may also declare your server information inside a hash named `server_info`:

    plugins:
      Apache-Solr:
        default:
          server_info:
            server: http://solr.example.com/productSearch/
            format => JSON
            server_version: 4.5

## alias

Aliases allow you to reference the same underlying server with multiple names.

For example:

    plugins:
      Apache-Solr:
        default:
            server: http://solr.example.com/productSearch/
        products:
          alias: default

Now you can access the default schema with `solr()`, `solr('default')`,
or `solr('products')`.

# FUNCTIONS

## solr

    my $results = solr->select( q => $searchString );

The `solr` keyword returns a [Apache::Solr](https://metacpan.org/pod/Apache::Solr) object ready for you to use.

If you have configured only one server, then you can simply call `solr` with no arguments.

If you have configured multiple server, you can still call `solr` with no arguments if there is a server named `default` in the configuration.

With no argument, the `default` server is returned.

Otherwise, you **must** provide `solr()` with the name of the server:

    my $user = solr('accessories')->select( ... );

# AUTHORS AND CONTRIBUTORS

This module is based on [Dancer::Plugin::DBIC](https://metacpan.org/pod/Dancer::Plugin::DBIC), as at 22 October 2014.

The following had authored [Dancer::Plugin::DBIC](https://metacpan.org/pod/Dancer::Plugin::DBIC) at this time:

- - Al Newkirk <awncorp@cpan.org>
- Naveed Massjouni <naveed@vt.edu>

The following had made contributions to [Dancer::Plugin::DBIC](https://metacpan.org/pod/Dancer::Plugin::DBIC) at this time:

- Alexis Sukrieh <sukria@sukria.net>
- Dagfinn Ilmari Mannsåker <[https://github.com/ilmari](https://github.com/ilmari)>
- David Precious <davidp@preshweb.co.uk>
- Fabrice Gabolde <[https://github.com/fgabolde](https://github.com/fgabolde)>
- Franck Cuny <franck@lumberjaph.net>
- Steven Humphrey <[https://github.com/shumphrey](https://github.com/shumphrey)>
- Yanick Champoux <[https://github.com/yanick](https://github.com/yanick)>

# AUTHORS

- Daniel Perrett <dp13@sanger.ac.uk>
- Al Newkirk <awncorp@cpan.org>
- Naveed Massjouni <naveed@vt.edu>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
