# SQL (Create table) to Json
Have you ever heard about that conversion? me neither... 
You can test it at https://osadsanu.github.io/SQLtoJson/
This simply program shows my first attempt to use [Dart](https://medium.com/@mswehli/why-dart-is-the-language-to-learn-of-2018-e5fa12adb6c1) for web proposes. 
Also i am playing with some RegExp
> *When confronted with a problem, think "I know, I'll use regular expressions." Now they have two problems* **Jamie Zawinski**

## Run it
1. Clone the repo 
    1. `pub install`
2. Test:
    1. `webdev serve`
Bonus! "compile" the dart js. and use it with git pages
1. Build:
    1. `webdev build  --output web:docs`
*if you have no idea what is that pls check this doc:*https://webdev.dartlang.org/tools/webdev

## Conversion
Converts SQL `Create Table` to JSON.
Now only it can convert really simple SQL like:
``` sql
CREATE TABLE song_artist(
sa_id serial,
sa_name character varying(100) NOT NULL,
sa_url character varying(100),
sa_hash numeric(11,0) NOT NULL,
au_hash numeric(11,0) NOT NULL,
sa_pop double precision NOT NULL,
sa_album character varying(100) NOT NULL,
CONSTRAINT song_artist_pkey PRIMARY KEY (sa_id, sa_hash),
CONSTRAINT unique_hash_sa UNIQUE (sa_hash))
```
to
```json
{
"tname":"song_artist",
"attribs":[
 	{"name":"sa_name","type":"character varying(100)","notNull":true},
	{"name":"sa_hash","type":"numeric(11,0)","notNull":true},
	{"name":"au_hash","type":"numeric(11,0)","notNull":true},
	{"name":"sa_pop","type":"double precision","notNull":true},
	{"name":"sa_album","type":"character varying(100)","notNull":true},
	{"name":"sa_id","type":"serial","notNull":false},
	{"name":"sa_url","type":"character varying(100)","notNull":false}
],
"constraint":[ 
"song_artist_pkey PRIMARY KEY (sa_id, sa_hash)",
"unique_hash_sa UNIQUE (sa_hash)"]
}
```

## How does it Work?
1. Take the text from the form.
   1. Using the next Regular expression to get the table name 
   `CREATE TABLE ([\w]+)`
      1. `CREATE TABLE`: Selects the lines that begin with that text.
      2. `()`: Creates a group
      3. `[\w]+`: get all the words
      4. Code Ex:
          ``` dart
          RegExp exp =   new   RegExp(r'CREATE TABLE ([\w]+)');
          String str = sqlfield.value;
          Iterable<Match> matches = exp.allMatches(str);
          for (Match m in matches) {
            data.tname = m.group(1);
          } 
          ```
    2. Using `([\w]+) ([\w \(\),]+) (NOT NULL)` to get all the lines but only getting the ones that include NOT NULL:
        1.    `([\w]+)`Selects the first word and uses for the table name
        2.    `([\w \(\),]+)` Selects the type (can contains `()`, `,` and `spaces` ), selects that on one group.
        3.    `(NOT NULL)` After match all the upper RegEx classes has to end with `(NOT NULL)` text.
        4. Code Ex:
        ```dart
        exp = new RegExp(r'([\w]+) ([\w \(\),]+) (NOT NULL)');
        str = sqlfield.value;
        matches = exp.allMatches(str);
        for (Match m in matches) {
          Attrib attr = new Attrib();
          attr.name=m.group(1);
          attr.type=m.group(2);
          attr.notNull=true;
          data.attribs.add(attr);
        }
        ```

