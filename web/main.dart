import 'dart:html';

TextAreaElement sqlfield; 
var result; 
var dson;
void main() {
  
  querySelector('#title').text = 'SQL to Json.';
  querySelector('#btnConvert').onClick.listen(updateTxt);
  
  sqlfield =  querySelector('#sql');
  result= querySelector('#result');
  
  //sqlfield.onChange.listen(updateTxt);
  sqlfield.value = "CREATE TABLE song_artist(\nsa_id serial,\nsa_name character varying(100) NOT NULL,\nsa_url character varying(100),\nsa_hash numeric(11,0) NOT NULL,\nau_hash numeric(11,0) NOT NULL,\nsa_pop double precision NOT NULL,\nsa_album character varying(100) NOT NULL,\nCONSTRAINT song_artist_pkey PRIMARY KEY (sa_id, sa_hash),\nCONSTRAINT unique_hash_sa UNIQUE (sa_hash))";
}
void updateTxt(Event e){
  result.value="";
  QueryTable data=new QueryTable();
  
  RegExp exp = new RegExp(r'CREATE TABLE ([\w]+)');
  String str = sqlfield.value;
  Iterable<Match> matches = exp.allMatches(str);
  for (Match m in matches) {
    data.tname = m.group(1);
    //tableName=match;
  }

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
  
  exp = new RegExp(r'([\w]+) (.*(\(.*,.*\))?.*),');
  str = sqlfield.value;
  matches =exp.allMatches(str);
  for(Match m in matches){
    if (m.group(0).contains("CREATE TABLE")||m.group(0).contains("NOT NULL")){
      continue;
    }else{
      if(m.group(1)=="CONSTRAINT"){
        continue;
      }else{
          Attrib attr = new Attrib();
          attr.name=m.group(1);
          attr.type=m.group(2);
          attr.notNull=false;
          data.attribs.add(attr);
          //([\w]+) ([\w \(\),]+),
      }
    }
  }
  String isNumber;
  exp = new RegExp(r'CONSTRAINT ([\w ]+\(.*\w\))');
  str = sqlfield.value;
  matches =exp.allMatches(str);
  for(Match m in matches){
    data.constraints.add(m.group(1));
  }
    //result.text= data.getAttribsStr();
  result.value='{\n"tname":"${data.tname}",\n${data.getAttribsStr()},\n${data.getConstraintStr()}\n}';
}
class QueryTable{
  String tname;
  List<Attrib> attribs;
  List<String> constraints;
  QueryTable(){
    this.attribs =new List<Attrib>();
    this.constraints =new List<String>();
  }
  String getAttribsStr(){
    String txtAttr= '"attribs":[\n ';
    for(int i =0; i<this.attribs.length;i++){
      if(i==this.attribs.length-1){
        txtAttr+= '\t{"name":"${this.attribs[i].name}","type":"${this.attribs[i].type}","notNull":${this.attribs[i].notNull}}\n';
      }else{
        txtAttr+= '\t{"name":"${this.attribs[i].name}","type":"${this.attribs[i].type}","notNull":${this.attribs[i].notNull}},\n';
      }
    }
    return txtAttr+="]";
  }
  String getConstraintStr(){
    String txtAttr= '"constraint":[ \n';
    for(int i =0; i<this.constraints.length;i++){
      if(i==this.constraints.length-1){
        txtAttr+= '\t"${this.constraints[i]}"';
      }else{
        txtAttr+= '\t"${this.constraints[i]}",\n';
      }
    }
    return txtAttr+="]";
  }
}
class Attrib{
  String name;
  String type;
  bool notNull;
}
