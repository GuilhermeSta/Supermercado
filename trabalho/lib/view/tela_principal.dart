import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaPrincipal()),
            );
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _shoppingLists = ['Lista de Compras Semanal', 'Lista de Compras de Supermercado'];

  Map<String, List<Item>> _itemsInShoppingLists = {};

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _shoppingLists.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supermercado'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _shoppingLists.map((list) => Tab(text: list)).toList(),
        ),
        backgroundColor: Color.fromARGB(255, 118, 240, 155),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _searchItem(),
          ),
          // Adicionando o ícone de informação (Sobre)
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Navegar para a tela Sobre
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SobrePage()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _shoppingLists.map((list) => _buildShoppingList(list)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addShoppingList,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildShoppingList(String listName) {
    return ListView(
      children: [
        ListTile(
          title: Text(listName),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editShoppingListName(listName),
          ),
          onLongPress: () => _removeShoppingList(listName),
        ),
        if (_itemsInShoppingLists.containsKey(listName))
          ..._itemsInShoppingLists[listName]!.asMap().entries.map((entry) {
            int index = entry.key;
            Item item = entry.value;
            return Dismissible(
              key: UniqueKey(),
              background: Container(color: Color.fromARGB(255, 207, 34, 34)),
              onDismissed: (direction) {
                setState(() {
                  _itemsInShoppingLists[listName]!.removeAt(index);
                });
              },
              child: ListTile(
                title: Text('${item.name} - ${item.quantity}'),
                trailing: Checkbox(
                  value: item.isBought,
                  onChanged: (value) {
                    setState(() {
                      item.isBought = value!;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    item.isBought = !item.isBought;
                  });
                },
                onLongPress: () => _editItemInList(listName, index),
              ),
            );
          }).toList(),
        ListTile(
          title: Text('Adicionar Item'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addItemToList(listName),
          ),
        ),
      ],
    );
  }

  void _addShoppingList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: Text('Adicionar Lista de Compras'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Nome da Lista'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _shoppingLists.add(_controller.text);
                    _tabController = TabController(length: _shoppingLists.length, vsync: this);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _editShoppingListName(String listName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController(text: listName);
        return AlertDialog(
          title: Text('Editar Nome da Lista'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Novo Nome'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    int index = _shoppingLists.indexOf(listName);
                    _shoppingLists[index] = _controller.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removeShoppingList(String listName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover Lista de Compras'),
          content: Text('Tem certeza que deseja remover a lista $listName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _shoppingLists.remove(listName);
                  _tabController = TabController(length: _shoppingLists.length, vsync: this);
                });
                Navigator.pop(context);
              },
              child: Text('Remover'),
            ),
          ],
        );
      },
    );
  }

  void _addItemToList(String listName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _itemController = TextEditingController();
        TextEditingController _quantityController = TextEditingController();
        return AlertDialog(
          title: Text('Adicionar Item à Lista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Nome do Item'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String itemName = _itemController.text;
                String quantity = _quantityController.text;
                if (itemName.isNotEmpty && quantity.isNotEmpty) {
                  setState(() {
                    if (!_itemsInShoppingLists.containsKey(listName)) {
                      _itemsInShoppingLists[listName] = [];
                    }
                    _itemsInShoppingLists[listName]!.add(Item(name: itemName, quantity: quantity, isBought: false));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _editItemInList(String listName, int index) {
    TextEditingController _itemController = TextEditingController(text: _itemsInShoppingLists[listName]![index].name);
    TextEditingController _quantityController = TextEditingController(text: _itemsInShoppingLists[listName]![index].quantity);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Item na Lista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Nome do Item'),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String itemName = _itemController.text;
                String quantity = _quantityController.text;
                if (itemName.isNotEmpty && quantity.isNotEmpty) {
                  setState(() {
                    _itemsInShoppingLists[listName]![index] = Item(name: itemName, quantity: quantity, isBought: _itemsInShoppingLists[listName]![index].isBought);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _searchItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesquisar Item'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Nome do Item'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  Navigator.pop(context);
                });
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String searchItem = _searchController.text;
                List<String> results = [];
                _shoppingLists.forEach((listName) {
                  if (_itemsInShoppingLists.containsKey(listName)) {
                    _itemsInShoppingLists[listName]!.forEach((item) {
                      if (item.name.toLowerCase().contains(searchItem.toLowerCase())) {
                        results.add('$searchItem está na lista $listName');
                      }
                    });
                  }
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Resultados da Pesquisa'),
                      content: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(results[index]),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Fechar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Pesquisar'),
            ),
          ],
        );
      },
    );
  }
}

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tema: Aplicativo de Lista de Compras',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Objetivo: Gerenciar listas de compras de supermercado',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Desenvolvido por: Guilherme Pereira - 831454',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final String quantity;
  bool isBought;

  Item({required this.name, required this.quantity, required this.isBought});
}