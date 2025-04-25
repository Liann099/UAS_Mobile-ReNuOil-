import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Poppins',
      ),
      home: const WithdrawScreen(),
    );
  }
}

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  bool _withdrawAllBalance = false;
  int _selectedBankIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFD358),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              _buildNavigationButtons(),
              Expanded(
                child: Container(
                  color: const Color(0xFFF5F5F5),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Funding Source',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildRefundBalanceCard(),
                          const SizedBox(height: 20),
                          _buildWithdrawalAmountCard(),
                          const SizedBox(height: 20),
                          _buildBankDestinationSection(),
                          const SizedBox(height: 30),
                          _buildWithdrawButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    // Replace with actual image when available
                    // image: DecorationImage(
                    //   image: AssetImage('assets/profile_pic.jpg'),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Start your search',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) {
                      // Implement search functionality here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildNavigationButtons() {
  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.account_balance_wallet, 'label': 'Balance'},
    {'customIcon': true, 'label': 'Withdraw'},
    {'icon': Icons.history, 'label': 'History'},
    {'icon': Icons.local_shipping, 'label': 'Track'},
  ];

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: navItems.map((item) {
        bool isSelected = item['label'] == 'Withdraw';
        return Column(
          children: [
            if (item['customIcon'] == true)
              // Custom withdraw icon
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD358),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              )
            else
              Icon(
                item['icon'],
                color: Colors.black87,
                size: 24,
              ),
            const SizedBox(height: 5),
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                width: 30,
                height: 3,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
          ],
        );
      }).toList(),
    ),
  );
}

  Widget _buildRefundBalanceCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFD358),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_downward,
              size: 28,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Refund Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Balance: Rp0',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalAmountCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFD358),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Withdrawal Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Rp.0',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey,
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Withdraw all balance',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
              Switch(
                value: _withdrawAllBalance,
                onChanged: (value) {
                  setState(() {
                    _withdrawAllBalance = value;
                  });
                },
                activeColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankDestinationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Bank Destination',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Your withdrawal of funds will be transferred to the selected destination account',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 15),
        _buildBankCard(
          'BCA',
          '5147 8816 8499 7303',
          'Matt',
          0,
          const Color(0xFFD6EBFF),
        ),
        const SizedBox(height: 15),
        _buildBankCard(
          'OCBC',
          '8428 1945 1234 8888',
          'Matt',
          1,
          const Color(0xFFFFC7C7),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Add New Bank Account',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankCard(String bankName, String accountNumber, String name, int index, Color bgColor) {
    bool isSelected = _selectedBankIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBankIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      accountNumber,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: $name',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.green : Colors.white,
                  ),
                  child: Icon(
                    Icons.check,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD358),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Withdraw Balance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}