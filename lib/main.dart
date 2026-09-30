import 'dart:async'; 
import 'dart:math'; 
import 'package:flutter/material.dart'; 
 
void main() { 
  runApp(const MyApp()); 
} 
 
List<Map<String, dynamic>> purchaseHistory = []; 
int globalToken = 20; 
 
// ================= APP ================= 
 
class MyApp extends StatelessWidget { 
  const MyApp({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(primarySwatch: Colors.green), 
      home: LoginScreen(), 
    ); 
  } 
} 
 
// ================= LOGIN ================= 
 
class LoginScreen extends StatelessWidget { 
  LoginScreen({super.key}); 
 
  final user = TextEditingController(); 
  final pass = TextEditingController(); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Container( 
        decoration: const BoxDecoration( 
          gradient: LinearGradient(colors: [Colors.green, Colors.teal]), 
        ), 
        child: Center( 
          child: Card( 
            shape: RoundedRectangleBorder( 
                borderRadius: BorderRadius.circular(20)), 
            child: Padding( 
              padding: const EdgeInsets.all(20), 
              child: Column(mainAxisSize: MainAxisSize.min, children: [ 
                const Text("Smart Ration Login", 
                    style: TextStyle(fontSize: 20)), 
                TextField(controller: user, decoration: const InputDecoration(labelText: "Username")), 
                TextField(controller: pass, decoration: const InputDecoration(labelText: "Password")), 
                const SizedBox(height: 10), 
                ElevatedButton( 
                  child: const Text("Login"), 
                  onPressed: () { 
                    Navigator.pushReplacement( 
                      context, 
                      MaterialPageRoute(builder: (_) => const DashboardScreen()), 
                    ); 
                  }, 
                ) 
              ]), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
} 
 
// ================= DASHBOARD ================= 
 
class DashboardScreen extends StatelessWidget { 
  const DashboardScreen({super.key}); 
 
  Widget card(String title, IconData icon, VoidCallback onTap) { 
    return Card( 
      child: ListTile( 
        leading: Icon(icon, color: Colors.green), 
        title: Text(title), 
        trailing: const Icon(Icons.arrow_forward), 
        onTap: onTap, 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text("Dashboard")), 
      body: Padding( 
        padding: const EdgeInsets.all(10), 
        child: Column(children: [ 
          card("Shop Ration", Icons.shopping_cart, () { 
            Navigator.push(context, 
                MaterialPageRoute(builder: (_) => const ProductScreen())); 
          }), 
          card("History", Icons.history, () { 
            Navigator.push(context, 
                MaterialPageRoute(builder: (_) => const HistoryScreen())); 
          }), 
        ]), 
      ), 
    ); 
  } 
} 
 
// ================= PRODUCT ================= 
 
class Product { 
  final int price; 
  final int stock; 
  final String unit; 
 
  Product({required this.price, required this.stock, this.unit = "kg"}); 
} 
 
class ProductScreen extends StatefulWidget { 
  const ProductScreen({super.key}); 
 
  @override 
  State<ProductScreen> createState() => _ProductScreenState(); 
} 
 
class _ProductScreenState extends State<ProductScreen> { 
  final Map<String, Product> products = { 
    "Rice": Product(price: 50, stock: 80), 
    "Wheat": Product(price: 40, stock: 60), 
    "Sugar": Product(price: 30, stock: 40), 
  }; 
 
  final Map<String, int> cart = {}; 
 
  void add(String item) { 
    setState(() { 
      cart[item] = (cart[item] ?? 0) + 1; 
    }); 
  } 
 
  void remove(String item) { 
    setState(() { 
      int q = cart[item] ?? 0; 
      if (q > 1) { 
        cart[item] = q - 1; 
      } else { 
        cart.remove(item); 
      } 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text("Products")), 
      floatingActionButton: cart.isNotEmpty 
          ? FloatingActionButton( 
              child: const Icon(Icons.shopping_cart), 
              onPressed: () { 
                Navigator.push( 
                  context, 
                  MaterialPageRoute( 
                      builder: (_) => CartScreen(cart, products)), 
                ); 
              }, 
            ) 
          : null, 
      body: ListView( 
        padding: const EdgeInsets.all(10), 
        children: products.keys.map((item) { 
          int q = cart[item] ?? 0; 
          Product p = products[item]!; 
 
          return Card( 
            child: ListTile( 
              title: Text(item), 
              subtitle: Text("₹${p.price}/kg | Stock: ${p.stock}"), 
              trailing: q == 0 
                  ? ElevatedButton( 
                      onPressed: () => add(item), 
                      child: const Text("Add"), 
                    ) 
                  : Row( 
                      mainAxisSize: MainAxisSize.min, 
                      children: [ 
                        IconButton(onPressed: () => remove(item), icon: const Icon(Icons.remove)), 
                        Text("$q ${p.unit}"), 
                        IconButton(onPressed: () => add(item), icon: const Icon(Icons.add)), 
                      ], 
                    ), 
            ), 
          ); 
        }).toList(), 
      ), 
    ); 
  } 
} 
 
// ================= CART ================= 
 
class CartScreen extends StatelessWidget { 
  final Map<String, int> cart; 
  final Map<String, Product> products; 
 
  const CartScreen(this.cart, this.products, {super.key}); 
 
  int total() { 
    int t = 0; 
    cart.forEach((k, v) { 
      t += products[k]!.price * v; 
    }); 
    return t; 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text("Cart")), 
      body: Column(children: [ 
        Expanded( 
          child: ListView( 
            children: cart.keys.map((k) { 
              return ListTile( 
                title: Text("$k - ${cart[k]} kg"), 
                trailing: Text("₹${products[k]!.price * cart[k]!}"), 
              ); 
            }).toList(), 
          ), 
        ), 
        Text("Total: ₹${total()}"), 
        ElevatedButton( 
          child: const Text("Continue"), 
          onPressed: () { 
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (_) => SlotScreen(cart, products, total())), 
            ); 
          }, 
        ) 
      ]), 
    ); 
  } 
} 
 
// ================= SLOT (AI) ================= 
 
class SlotScreen extends StatelessWidget { 
  final Map<String, int> cart; 
  final Map<String, Product> products; 
  final int total; 
 
  const SlotScreen(this.cart, this.products, this.total, {super.key}); 
 
  static const Map<String, int> baseCrowd = { 
    "9-10 AM": 5, 
    "11-12 PM": 8, 
    "2-3 PM": 3, 
  }; 
 
  int predict(String slot) => 
      baseCrowd[slot]! + Random().nextInt(3); 
 
  String bestSlot() { 
    String best = ""; 
    int min = 999; 
    baseCrowd.forEach((k, v) { 
      int p = predict(k); 
      if (p < min) { 
        min = p; 
        best = k; 
      } 
    }); 
    return best; 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    String recommend = bestSlot(); 
 
    return Scaffold( 
      appBar: AppBar(title: const Text("Select Slot")), 
      body: Column(children: [ 
        Container( 
          padding: const EdgeInsets.all(15), 
          color: Colors.green, 
          child: Text("AI Recommended: $recommend", 
              style: const TextStyle(color: Colors.white)), 
        ), 
        Expanded( 
          child: ListView( 
            children: baseCrowd.keys.map((slot) { 
              return Card( 
                child: ListTile( 
                  title: Text(slot), 
                  subtitle: 
                      Text("Predicted Crowd: ${predict(slot)}"), 
                  trailing: ElevatedButton( 
                    child: const Text("Select"), 
                    onPressed: () { 
                      Navigator.push( 
                        context, 
                        MaterialPageRoute( 
                          builder: (_) => 
                              PaymentScreen(cart, products, total, slot), 
                        ), 
                      ); 
                    }, 
                  ), 
                ), 
              ); 
            }).toList(), 
          ), 
        ), 
      ]), 
    ); 
  } 
} 
 
// ================= PAYMENT ================= 
 
class PaymentScreen extends StatelessWidget { 
  final Map<String, int> cart; 
  final Map<String, Product> products; 
  final int total; 
  final String slot; 
 
  const PaymentScreen( 
      this.cart, this.products, this.total, this.slot, 
      {super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text("Payment")), 
      body: Column(children: [ 
        ListTile( 
          title: const Text("UPI"), 
          trailing: ElevatedButton( 
            child: const Text("Pay"), 
            onPressed: () { 
              Navigator.push( 
                context, 
                MaterialPageRoute( 
                  builder: (_) => 
                      BillScreen(cart, products, total, slot, "UPI"), 
                ), 
              ); 
            }, 
          ), 
        ), 
        ListTile( 
          title: const Text("Cash"), 
          trailing: ElevatedButton( 
            child: const Text("Select"), 
            onPressed: () { 
              Navigator.push( 
                context, 
                MaterialPageRoute( 
                  builder: (_) => 
                      BillScreen(cart, products, total, slot, "Cash"), 
                ), 
              ); 
            }, 
          ), 
        ), 
      ]), 
    ); 
  } 
} 
 
// ================= BILL ================= 
 
class BillScreen extends StatelessWidget { 
  final Map<String, int> cart; 
  final Map<String, Product> products; 
  final int total; 
  final String slot; 
  final String method; 
 
  const BillScreen( 
      this.cart, this.products, this.total, this.slot, this.method, 
      {super.key}); 
 
  String billNo() => "BILL-${10000 + Random().nextInt(90000)}"; 
 
  @override 
  Widget build(BuildContext context) { 
    String id = billNo(); 
    int token = ++globalToken; 
 
    return Scaffold( 
      appBar: AppBar(title: const Text("Bill")), 
      body: Column(children: [ 
        Text("Bill: $id"), 
        Text("Token: #$token"), 
        Text("Slot: $slot"), 
        Text("Payment: $method"), 
        Expanded( 
          child: ListView( 
            children: cart.keys.map((k) { 
              return ListTile( 
                title: Text("$k - ${cart[k]} kg"), 
                trailing: Text("₹${products[k]!.price * cart[k]!}"), 
              ); 
            }).toList(), 
          ), 
        ), 
        Text("Total: ₹$total"), 
        ElevatedButton( 
          child: const Text("Confirm"), 
          onPressed: () { 
            purchaseHistory.add({ 
              "bill": id, 
              "token": token, 
              "slot": slot, 
              "method": method, 
              "total": total, 
              "items": Map<String, int>.from(cart), 
            }); 
 
            Navigator.push( 
              context, 
              MaterialPageRoute( 
                  builder: (_) => ConfirmScreen(slot, token)), 
            ); 
          }, 
        ) 
      ]), 
    ); 
  } 
} 
 
// ================= CONFIRM ================= 
 
class ConfirmScreen extends StatelessWidget { 
  final String slot; 
  final int token; 
 
  const ConfirmScreen(this.slot, this.token, {super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Center( 
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ 
          const Icon(Icons.check_circle, size: 80, color: Colors.green), 
          Text("Token: #$token"), 
          ElevatedButton( 
            child: const Text("Track Queue"), 
            onPressed: () { 
              Navigator.pushReplacement( 
                context, 
                MaterialPageRoute( 
                    builder: (_) => 
                        QueueScreen(slot: slot, token: token)), 
              ); 
            }, 
          ) 
        ]), 
      ), 
    ); 
  } 
} 
 
// ================= QUEUE ================= 
 
class QueueScreen extends StatefulWidget { 
  final String slot; 
  final int token; 
 
  const QueueScreen({super.key, required this.slot, required this.token}); 
 
  @override 
  State<QueueScreen> createState() => _QueueScreenState(); 
} 
 
class _QueueScreenState extends State<QueueScreen> { 
  late int currentToken; 
  Timer? timer; 
 
  @override 
  void initState() { 
    super.initState(); 
 
    currentToken = widget.token - (Random().nextInt(5) + 1); 
    if (currentToken < 1) currentToken = 1; 
 
    timer = Timer.periodic(const Duration(seconds: 3), (t) { 
      if (currentToken < widget.token) { 
        setState(() { 
          currentToken++; 
        }); 
      } else { 
        t.cancel(); 
      } 
    }); 
  } 
 
  @override 
  void dispose() { 
    timer?.cancel(); 
    super.dispose(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    int peopleAhead = widget.token - currentToken; 
 
    return Scaffold( 
      appBar: AppBar(title: const Text("Live Queue")), 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            Text("Your Token: #${widget.token}"), 
            Text("Now Serving: #$currentToken"), 
            Text("People Ahead: ${peopleAhead > 0 ? peopleAhead : 0}"), 
            Text(peopleAhead <= 0 ? "Your Turn!" : "Please wait"), 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 
// ================= HISTORY ================= 
 
class HistoryScreen extends StatelessWidget { 
  const HistoryScreen({super.key}); 
 
  Widget items(Map<String, int> data) { 
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: data.keys.map((k) { 
        return Text("$k - ${data[k]} kg"); 
      }).toList(), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar(title: const Text("History")), 
      body: purchaseHistory.isEmpty 
          ? const Center(child: Text("No Data")) 
          : ListView( 
              children: purchaseHistory.map((e) { 
                return Card( 
                  child: ListTile( 
                    title: Text("${e['bill']} (Token #${e['token']})"), 
                    subtitle: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        Text("Slot: ${e['slot']}"), 
                        Text("Payment: ${e['method']}"), 
                        items(Map<String, int>.from(e['items'])), 
                        Text("Total: ₹${e['total']}"), 
                      ], 
                    ), 
                  ), 
                ); 
              }).toList(), 
            ), 
    ); 
  } 
} HOW TO SAVE IN THIS GITHUB
