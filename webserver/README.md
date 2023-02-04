A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.


This webserver reads supabase credentials from file .supabase_db_creds, should be located in your $HOME dir
JSON:
```json
{   
    "dbUrl" : "supabase.url",
    "dbPassword" : "supabase.password"
}
```


```bash
cat ~/.supabase_db_creds
# should return the JSON provided above, with your creds ofc.
```

Run with
```bash
dart run bin/webserver.dart --port 8069
```