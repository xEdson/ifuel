class Nota{
   int _id;
   double _nota;

   Nota(this._id, this._nota, this._idPosto);

   String _idPosto;

   int get id => _id;

   set id(int value) {
     _id = value;
   }

   double get nota => _nota;

   set nota(double value) {
     _nota = value;
   }

   String get idPosto => _idPosto;

   set idPosto(String value) {
     _idPosto = value;
   }

   Nota.fromMap(Map map) {
     id = map["id"];
     nota = map["nota"];
     idPosto = map["idPosto"];
   }

   Map toMap() {

     Map<String, dynamic> map = {
       "id":id,
       "nota": nota,
       "idPosto" : idPosto,
     };
     if (id != null) {
       map["id"] = id;
     }
     return map;
   }
}