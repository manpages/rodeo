erl -pa ebin ./core/saloon/ebin ./deps/*/ebin ./site/ebin -name rodeo@127.0.0.1 -boot start_sasl -run make all load -s saloon_app
