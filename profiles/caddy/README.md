
<pre>
mkdir -p /data/tools/caddy-work /var/log/caddy/
</pre>

<pre>
platform.voicezen.ai:80 {
    log stdout

    # root points to the dist folder of yarn build
    root /data/wip/trans-files/work/voicezen-ui/dist

    # for all static content we want to hit root, this is for "cdr" and any such vue route
    rewrite {
        regexp .*
        if {path} not_starts_with /reports
        to {path} /

    }

    proxy /reports http://localhost:9080 {
        without /reports
    }
    header /reports Access-Control-Allow-Origin *
    header /reports Access-Control-Allow-Headers content-type,authorization
    header /reports/* Access-Control-Allow-Origin *
    header /reports/* Access-Control-Allow-Headers content-type,authorization

}
</pre>
