import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ضروري للـ Formatters
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import 'payment_screen.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // تحديث الدالة لتقبل نوع لوحة المفاتيح والـ Formatters
  Widget buildField(
    String label, 
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType, // لتحديد نوع لوحة المفاتيح
          inputFormatters: inputFormatters, // لتحديد القيود (أرقام فقط، الحد الأقصى)
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 232, 230, 230),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddressProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Address')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildField('Name', nameController, validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your name';
                  return null;
                }),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildField('Country', countryController, validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        return null;
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildField('City', cityController, validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        return null;
                      }),
                    ),
                  ],
                ),

                // حقل رقم الهاتف مع القيود المطلوبة
                buildField(
                  'Phone Number', 
                  phoneController, 
                  keyboardType: TextInputType.number, // يفتح لوحة أرقام
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // يمنع كتابة الحروف
                    LengthLimitingTextInputFormatter(11),   // يمنع كتابة أكثر من 11 رقم
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 11) return 'Must be 11 digits';
                    return null;
                  },
                ),

                buildField('Address', addressController, validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return null;
                }),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await provider.saveAddress(
                                  name: nameController.text.trim(),
                                  country: countryController.text.trim(),
                                  city: cityController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  address: addressController.text.trim(),
                                );

                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => PaymentScreen()),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save & Proceed to Payment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}