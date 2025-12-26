import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ضروري للقيود (Formatters)
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import 'success_screen.dart';

class PaymentScreen extends StatelessWidget {
  // 1. تعريف المفتاح الخاص بالـ Form
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final paymentProv = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Payment Details", style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form( // 2. تغليف الحقول بـ Form
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  "Card Number",
                  "5123 4567 8901 2345",
                  cardController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (value) {
                    if (value == null || value.length < 16) return "Enter 16 digits";
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTextField(
                        "Expiry Date",
                        "MM/YY",
                        dateController,
                        validator: (value) {
                          if (value == null || !value.contains('/')) return "Use MM/YY";
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildTextField(
                        "CVV",
                        "123",
                        cvvController,
                        isObscure: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: (value) {
                          if (value == null || value.length < 3) return "Required";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  "Card Holder Name",
                  "John Doe",
                  nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Name is required";
                    return null;
                  },
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // 3. تغيير اللون للبنفسجي
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: paymentProv.isLoading
                        ? null
                        : () {
                            // 4. التحقق من الصحة قبل الدفع
                            if (_formKey.currentState!.validate()) {
                              paymentProv.processPayment(
                                cardNumber: cardController.text,
                                expiryDate: dateController.text,
                                cardHolderName: nameController.text,
                                cvvCode: cvvController.text,
                                amount: 450.0,
                                onSuccess: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => SuccessScreen()),
                                ),
                              );
                            }
                          },
                    child: paymentProv.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Pay Now",
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تحديث الـ Widget ليدعم الـ Validation والقيود
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController? controller, {
    bool isObscure = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          TextFormField( // استخدام TextFormField بدلاً من TextField
            controller: controller,
            obscureText: isObscure,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[100],
              errorStyle: TextStyle(color: Colors.red),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.purple)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}