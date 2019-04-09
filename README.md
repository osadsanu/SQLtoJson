# SQL (Create table) to Json
#About
Have you ever heard about that conversion? me neither... 
This simple shows my first attemp to use Dart for web propuses. Also playing with some RegExp.
##Conversion
Converts SQL 'Create Table' to json.
for now only it can convert really simple SQL like:
```
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
```
{
"tname":song_artist,
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