import 'dart:convert';

class Chambre {
  String numero;
  String idBatiment;
  int nbrLit;
  int nbrSallesBains;
  int nbrCuisine;
  String typologie;
  double superficie;
  String? id;
  Chambre(
      {required this.numero,
      required this.idBatiment,
      required this.nbrLit,
      required this.nbrSallesBains,
      required this.nbrCuisine,
      required this.typologie,
      required this.superficie,
      // document Id can be null if the element is new
      this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numero': numero,
      'idBatiment': idBatiment,
      'nbrLit': nbrLit,
      'nbrSallesBains': nbrSallesBains,
      'nbrCuisine': nbrCuisine,
      'typologie': typologie,
      'superficie': superficie,
    };
  }

  Map<String, dynamic> toMapFirebase() {
    return <String, dynamic>{
      "numero": numero,
      "batiment": idBatiment,
      "lits": nbrLit,
      "salleDeBains": nbrSallesBains,
      "cuisines": nbrCuisine,
      "typologie": typologie,
      "superficie": superficie,
    };
  }

  factory Chambre.fromMapFirebase(Map<String, dynamic> map) {
    return Chambre(
        numero: map['numero'] as String,
        idBatiment: map['batiment'] as String,
        nbrLit: map['lits'] as int,
        nbrSallesBains: map['salleDeBains'] as int,
        nbrCuisine: map['cuisines'] as int,
        typologie: map['typologie'] as String,
        superficie: map['superficie'].runtimeType == int
            ? (map['superficie'] as int).toDouble()
            : map['superficie'] as double);
  }

  factory Chambre.fromMap(Map<String, dynamic> map) {
    return Chambre(
      numero: map['numero'] as String,
      idBatiment: map['idBatiment'] as String,
      nbrLit: map['nbrLit'] as int,
      nbrSallesBains: map['nbrSallesBains'] as int,
      nbrCuisine: map['nbrCuisine'] as int,
      typologie: map['typologie'] as String,
      superficie: map['superficie'] as double,
    );
  }

  String toJson() => json.encode(toMap());
  String toJsonFirebase() => json.encode(toMapFirebase());

  factory Chambre.fromJson(String source) =>
      Chambre.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chambre(numero: $numero, idBatiment: $idBatiment, nbrLit: $nbrLit, nbrSallesBains: $nbrSallesBains, nbrCuisine: $nbrCuisine, typologie: $typologie, superficie: $superficie)';
  }

  @override
  bool operator ==(covariant Chambre other) {
    if (identical(this, other)) return true;

    return other.numero == numero &&
        other.idBatiment == idBatiment &&
        other.nbrLit == nbrLit &&
        other.nbrSallesBains == nbrSallesBains &&
        other.nbrCuisine == nbrCuisine &&
        other.typologie == typologie &&
        other.superficie == superficie &&
        other.id == id;
  }

  @override
  int get hashCode {
    return numero.hashCode ^
        idBatiment.hashCode ^
        nbrLit.hashCode ^
        nbrSallesBains.hashCode ^
        nbrCuisine.hashCode ^
        typologie.hashCode ^
        superficie.hashCode;
  }
}
