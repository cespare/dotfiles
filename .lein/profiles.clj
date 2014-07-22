{:user {:plugins [[lein-exec "0.3.0"]
                  [jonase/eastwood "0.1.2"]]
        :dependencies [[org.clojure/tools.namespace "0.2.4"]
                       [criterium "0.4.2"]
                       [slamhound "1.5.5"]]
        :aliases {"slamhound" ["run" "-m" "slam.hound"]}}}
