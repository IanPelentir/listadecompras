class Item {
  int? id;
  String nome;
  int quantidade;
  bool comprado;

  Item({this.id, required this.nome, required this.quantidade, this.comprado = false});

  // Converte o item para um mapa para armazenar no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'comprado': comprado ? 1 : 0,
    };
  }

  // Converte o mapa do banco de volta para um objeto Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      comprado: map['comprado'] == 1,
    );
  }
}
