#!/usr/bin/env ruby

# Run this on a markdown file to view rendered in browser.

require "rubygems"
require "github/markup"

TEMP_FILE = "/var/markdown/markdown.html"

puts ARGV[0]
if ARGV.size < 1 || ARGV[0] !~ /([^\.]+\.(md|markdown))/ || !File.file?(ARGV[0])
  abort "Usage: markdown.rb <markdown_filename>"
end

filename = ARGV[0]
marked_down_text = GitHub::Markup.render(filename, File.read(filename))
File.open(TEMP_FILE, "w") do |file|
  file.puts(eval DATA.read)
end

`open #{TEMP_FILE}`

__END__
"""
<html>
  <head>
    <title>#{filename}</title>
      <style type=\"text/css\">

      /*****************************************************************************/
      /*
      /* Common
      /*
      /*****************************************************************************/

      /* Global Reset */

      * {
        margin: 0;
        padding: 0;
      }

      html, body {
        height: 100%;
      }

      body {
        background-color: white;
        font: 13.34px helvetica, arial, clean, sans-serif;
        *font-size: small;
        text-align: center;
      }

      h1, h2, h3, h4, h5, h6 {
        font-size: 100%;
      }

      h1 {
        margin-bottom: 1em;
      }

      p {
        margin: 1em 0;
      }

      a {
        color: #00a;
      }

      a:hover {
        color: black;
      }

      a:visited {
        color: #a0a;
      }

      table {
        font-size: inherit;
        font: 100%;
      }

      /*****************************************************************************/
      /*
      /* Home
      /*
      /*****************************************************************************/

      ul.posts {
        list-style-type: none;
        margin-bottom: 2em;
      }

        ul.posts li {
          line-height: 1.75em;
        }

        ul.posts span {
          color: #aaa;
          font-family: Monaco, \"Courier New\", monospace;
          font-size: 80%;
        }

      /*****************************************************************************/
      /*
      /* Site
      /*
      /*****************************************************************************/

      .site {
        font-size: 110%;
        text-align: justify;
        width: 40em;
        margin: 3em auto 2em auto;
        line-height: 1.5em;
      }

      .title {
        color: #a00;
        font-weight: bold;
        margin-bottom: 2em;
      }

        .site .title a {
          color: #a00;
          text-decoration: none;
        }

        .site .title a:hover {
          color: black;
        }

        .site .title a.extra {
          color: #aaa;
          text-decoration: none;
          margin-left: 1em;
        }

        .site .title a.extra:hover {
          color: black;
        }

        .site .meta {
          color: #aaa;
        }

        .site .footer {
          font-size: 80%;
          color: #666;
          border-top: 4px solid #eee;
          margin-top: 2em;
          overflow: hidden;
        }

          .site .footer .contact {
            float: left;
            margin-right: 3em;
          }

            .site .footer .contact a {
              color: #8085C1;
            }

          .site .footer .rss {
            margin-top: 1.1em;
            margin-right: -.2em;
            float: right;
          }

            .site .footer .rss img {
              border: 0;
            }

      /*****************************************************************************/
      /*
      /* Posts
      /*
      /*****************************************************************************/

      #post {

      }

        /* standard */

        #post pre {
          border: 1px solid #ddd;
          background-color: #eef;
          padding: 0 .4em;
        }

        #post ul,
        #post ol {
          margin-left: 1.25em;
        }

        #post code {
          border: 1px solid #ddd;
          background-color: #eef;
          font-size: 95%;
          padding: 0 .2em;
        }

          #post pre code {
            border: none;
          }

        /* terminal */

        #post pre.terminal {
          border: 1px solid black;
          background-color: #333;
          color: white;
        }

        #post pre.terminal code {
          background-color: #333;
        }

      #related {
        margin-top: 2em;
      }

        #related h2 {
          margin-bottom: 1em;
        }


      .highlight  { background: #ffffff; }
      .highlight .c { color: #999988; font-style: italic } /* Comment */
      .highlight .err { color: #a61717; background-color: #e3d2d2 } /* Error */
      .highlight .k { font-weight: bold } /* Keyword */
      .highlight .o { font-weight: bold } /* Operator */
      .highlight .cm { color: #999988; font-style: italic } /* Comment.Multiline */
      .highlight .cp { color: #999999; font-weight: bold } /* Comment.Preproc */
      .highlight .c1 { color: #999988; font-style: italic } /* Comment.Single */
      .highlight .cs { color: #999999; font-weight: bold; font-style: italic } /* Comment.Special */
      .highlight .gd { color: #000000; background-color: #ffdddd } /* Generic.Deleted */
      .highlight .gd .x { color: #000000; background-color: #ffaaaa } /* Generic.Deleted.Specific */
      .highlight .ge { font-style: italic } /* Generic.Emph */
      .highlight .gr { color: #aa0000 } /* Generic.Error */
      .highlight .gh { color: #999999 } /* Generic.Heading */
      .highlight .gi { color: #000000; background-color: #ddffdd } /* Generic.Inserted */
      .highlight .gi .x { color: #000000; background-color: #aaffaa } /* Generic.Inserted.Specific */
      .highlight .go { color: #888888 } /* Generic.Output */
      .highlight .gp { color: #555555 } /* Generic.Prompt */
      .highlight .gs { font-weight: bold } /* Generic.Strong */
      .highlight .gu { color: #aaaaaa } /* Generic.Subheading */
      .highlight .gt { color: #aa0000 } /* Generic.Traceback */
      .highlight .kc { font-weight: bold } /* Keyword.Constant */
      .highlight .kd { font-weight: bold } /* Keyword.Declaration */
      .highlight .kp { font-weight: bold } /* Keyword.Pseudo */
      .highlight .kr { font-weight: bold } /* Keyword.Reserved */
      .highlight .kt { color: #445588; font-weight: bold } /* Keyword.Type */
      .highlight .m { color: #009999 } /* Literal.Number */
      .highlight .s { color: #d14 } /* Literal.String */
      .highlight .na { color: #008080 } /* Name.Attribute */
      .highlight .nb { color: #0086B3 } /* Name.Builtin */
      .highlight .nc { color: #445588; font-weight: bold } /* Name.Class */
      .highlight .no { color: #008080 } /* Name.Constant */
      .highlight .ni { color: #800080 } /* Name.Entity */
      .highlight .ne { color: #990000; font-weight: bold } /* Name.Exception */
      .highlight .nf { color: #990000; font-weight: bold } /* Name.Function */
      .highlight .nn { color: #555555 } /* Name.Namespace */
      .highlight .nt { color: #000080 } /* Name.Tag */
      .highlight .nv { color: #008080 } /* Name.Variable */
      .highlight .ow { font-weight: bold } /* Operator.Word */
      .highlight .w { color: #bbbbbb } /* Text.Whitespace */
      .highlight .mf { color: #009999 } /* Literal.Number.Float */
      .highlight .mh { color: #009999 } /* Literal.Number.Hex */
      .highlight .mi { color: #009999 } /* Literal.Number.Integer */
      .highlight .mo { color: #009999 } /* Literal.Number.Oct */
      .highlight .sb { color: #d14 } /* Literal.String.Backtick */
      .highlight .sc { color: #d14 } /* Literal.String.Char */
      .highlight .sd { color: #d14 } /* Literal.String.Doc */
      .highlight .s2 { color: #d14 } /* Literal.String.Double */
      .highlight .se { color: #d14 } /* Literal.String.Escape */
      .highlight .sh { color: #d14 } /* Literal.String.Heredoc */
      .highlight .si { color: #d14 } /* Literal.String.Interpol */
      .highlight .sx { color: #d14 } /* Literal.String.Other */
      .highlight .sr { color: #009926 } /* Literal.String.Regex */
      .highlight .s1 { color: #d14 } /* Literal.String.Single */
      .highlight .ss { color: #990073 } /* Literal.String.Symbol */
      .highlight .bp { color: #999999 } /* Name.Builtin.Pseudo */
      .highlight .vc { color: #008080 } /* Name.Variable.Class */
      .highlight .vg { color: #008080 } /* Name.Variable.Global */
      .highlight .vi { color: #008080 } /* Name.Variable.Instance */
      .highlight .il { color: #009999 } /* Literal.Number.Integer.Long */

    </style>
    </head>
    <body>
      <div class=\"site\">
        <div id=\"post\">
        #{marked_down_text}
        </div>
      </div>
    </body>
  </html>
"""
