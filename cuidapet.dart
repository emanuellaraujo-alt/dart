import 'dart:io';

const String CITY = "Guaxupé";
const String ROAD = "Rua Domingos Zacherel";
const String NUMBER = "201";
const String RESTRICTED_CODE = "cuidapetrestrito";
const int CART_LIMIT = 3;

final Map<int, Map<String, dynamic>> CATALOG = {
  101: {
    "name": "Ração Royal Canin Indoor Para Cães Adultos De Porte Mini De Ambientes Internos 7,5kg",
    "price": 290.00,
  },
  102: {
    "name": "Ração Royal Canin Sterilised para Gatos Adultos Castrados",
    "price": 492.00,
  },
  103: {
    "name": "Bifinho Keldog para Cães Porte Pequeno Sabor Carne e Cereais",
    "price": 23.92,
  },
  104: {
    "name": "Fraldas Descartáveis Super Secão para Cães Machos com 12 Unidades",
    "price": 38.61,
  },
  201: {"name": "Banho e tosa", "price": 55.99},
  202: {"name": "Tosa higiênica", "price": 12.99},
  203: {"name": "Hidratação dos pelos", "price": 20.99},
};

String readStringInput(String message) {
  stdout.write(message);
  String? input = stdin.readLineSync();
  return input ?? "";
}

int readIntInput(String message) {
  while (true) {
    stdout.write(message);
    String? input = stdin.readLineSync();
    try {
      return int.parse(input ?? "");
    } catch (e) {
      print("\nEntrada inválida! Digite um número.");
    }
  }
}

double readDoubleInput(String message) {
  while (true) {
    stdout.write(message);
    String? input = stdin.readLineSync();
    try {
      return double.parse(input ?? "");
    } catch (e) {
      print("\nEntrada inválida! Digite um número válido.");
    }
  }
}

void showWelcome() {
  print("\n--------------------------- X ---------------------------");
  print("Bem vindo ao autoatendimento do Cuidapet!");
  print("\nEndereço:");
  print("* Cidade: $CITY");
  print("* Rua: $ROAD");
  print("* Número: $NUMBER");
}

void showMainMenu(String name) {
  print("\nPrezado(a), $name. Seja muito bem-vindo(a) ao nosso autoatendimento.\n");
  print("  1 - Ver promoções");
  print("  2 - Solicitar serviço");
  print("  3 - Listar carrinho de compra");
  print("  4 - Finalizar carrinho de compra");
  print("  0 - Sair");
  stdout.write("\nDigite sua opção desejada: ");
}

void showPromotionsMenu() {
  print("\nPromoções disponíveis:");
  print("  Código 101 - Ração Royal Canin Indoor Para Cães Adultos De Porte Mini De Ambientes Internos 7,5kg -- R\$ 290,00");
  print("  Código 102 - Ração Royal Canin Sterilised para Gatos Adultos Castrados -- R\$ 492,00");
  print("  Código 103 - Bifinho Keldog para Cães Porte Pequeno Sabor Carne e Cereais -- R\$ 23,92");
  print("  Código 104 - Fraldas Descartáveis Super Secão para Cães Machos com 12 Unidades -- R\$ 38,61");
  print("\n  8 - Adicionar ao carrinho de compras");
  print("  0 - Voltar");
  stdout.write("\nOpção: ");
}

void showServicesMenu() {
  print("\nServiços disponíveis:");
  print("  Código 201 - Banho e tosa -- R\$ 55,99");
  print("  Código 202 - Tosa higiênica -- R\$ 12,99");
  print("  Código 203 - Hidratação dos pelos -- R\$ 20,99");
  print("\n  8 - Adicionar ao carrinho de compras");
  print("  0 - Voltar");
  stdout.write("\nOpção: ");
}

void showCart(List<Map<String, dynamic>> cart) {
  if (cart.isEmpty) {
    print("\nSeu carrinho está vazio.");
    return;
  }
  print("\nItens no carrinho:");
  double total = 0;
  for (var item in cart) {
    print("  - ${item['name']} -- R\$ ${(item['price'] as double).toStringAsFixed(2)}");
    total += item['price'] as double;
  }
  print("Total parcial: R\$ ${total.toStringAsFixed(2)}");
}

void addToCart(List<Map<String, dynamic>> cart) {
  if (cart.length >= CART_LIMIT) {
    print("\nSeu carrinho de compras já está cheio.");
    return;
  }
  
  int code = readIntInput("Digite o código do produto: ");
  
  if (!CATALOG.containsKey(code)) {
    print("\nCódigo inválido.");
    return;
  }
  
  cart.add(Map.from(CATALOG[code]!));
  print("\nProduto adicionado ao carrinho.");
}

double applyPaymentDiscount(double total) {
  print("\nForma de pagamento:");
  print("  D - Dinheiro (10% de desconto)");
  print("  C - Cartão");
  stdout.write("\nOpção: ");
  
  String payment = readStringInput("").toUpperCase();
  
  while (payment != "D" && payment != "C") {
    print("\nOpção inválida!");
    stdout.write("Opção: ");
    payment = readStringInput("").toUpperCase();
  }
  
  if (payment == "D") {
    double discount = total * 0.10;
    total -= discount;
    print("Desconto de 10%: -R\$ ${discount.toStringAsFixed(2)}");
  }
  
  print("Valor final: R\$ ${total.toStringAsFixed(2)}");
  return total;
}

double checkout(List<Map<String, dynamic>> cart) {
  if (cart.isEmpty) {
    print("\nCarrinho vazio. Nada a finalizar.");
    return 0;
  }
  
  double total = cart.fold(0.0, (sum, item) => sum + (item['price'] as double));
  print("\nTotal dos itens: R\$ ${total.toStringAsFixed(2)}");
  return applyPaymentDiscount(total);
}

void handleSubMenu(List<Map<String, dynamic>> cart, bool isPromotions) {
  bool inSubMenu = true;
  
  while (inSubMenu) {
    if (isPromotions) {
      showPromotionsMenu();
    } else {
      showServicesMenu();
    }
    
    int option = readIntInput("");
    
    switch (option) {
      case 8:
        addToCart(cart);
        break;
      case 0:
        inSubMenu = false;
        break;
      default:
        print("\nOpção inválida.");
    }
  }
}

double employeeArea() {
  print("\n--- ÁREA RESTRITA ---");
  
  String clientName = readStringInput("Nome do cliente: ");
  
  if (clientName.isEmpty) {
    print("\nNome inválido. Operação cancelada.");
    return 0;
  }
  
  double amount = readDoubleInput("Valor gasto na loja: R\$ ");
  
  if (amount <= 0) {
    print("\nValor inválido. Operação cancelada.");
    return 0;
  }
  
  print("\nCliente: $clientName");
  print("Valor original: R\$ ${amount.toStringAsFixed(2)}");
  
  double finalAmount = applyPaymentDiscount(amount);
  
  print("\nVenda registrada com sucesso!");
  return finalAmount;
}

void showDailyReport(int salesCount, double totalSales) {
  print("\n--------------------------- X ---------------------------");
  print("Vendas do dia: $salesCount");
  print("Total arrecadado: R\$ ${totalSales.toStringAsFixed(2)}");
}

void main() {
  int salesCount = 0;
  double totalSales = 0;
  bool running = true;
  
  while (running) {
    showWelcome();
    String name = readStringInput("\nQual seu nome? ");
    
    if (name.isEmpty) {
      print("\nNome não pode ser vazio.");
      continue;
    }
    
    if (name == RESTRICTED_CODE) {
      double saleValue = employeeArea();
      if (saleValue > 0) {
        salesCount++;
        totalSales += saleValue;
      }
      continue;
    }
    
    List<Map<String, dynamic>> cart = [];
    bool clientActive = true;
    
    while (clientActive) {
      showMainMenu(name);
      int option = readIntInput("");
      
      switch (option) {
        case 1:
          handleSubMenu(cart, true);
          break;
        case 2:
          handleSubMenu(cart, false);
          break;
        case 3:
          showCart(cart);
          break;
        case 4:
          double saleValue = checkout(cart);
          if (saleValue > 0) {
            salesCount++;
            totalSales += saleValue;
            cart.clear();
          }
          break;
        case 0:
          clientActive = false;
          running = false;
          break;
        default:
          print("\nOpção inválida. Por favor, digite uma opção de 0 a 4.");
      }
    }
  }
  
  showDailyReport(salesCount, totalSales);
}