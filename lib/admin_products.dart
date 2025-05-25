import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final _productsCollection = FirebaseFirestore.instance.collection('products');

  Future<void> _showAddOrEditProductDialog({DocumentSnapshot? productDoc}) async {
    final _formKey = GlobalKey<FormState>();

    // Fix: capitalize initial category to match dropdown values exactly
    String category = productDoc?.get('category') ?? 'Pizza';
    String name = productDoc?.get('name') ?? '';
    String description = productDoc?.get('description') ?? '';
    double price = (productDoc?.get('price') ?? 0).toDouble();
    int stock = (productDoc?.get('stock') ?? 0);
    Uint8List? imageBytes;
    String? imageFileName;
    String? existingImageUrl = productDoc?.get('imageUrl');
    bool isUploading = false;
    double uploadProgress = 0.0;

    Future<void> _uploadAndSaveProduct() async {
      setState(() {
        isUploading = true;
        uploadProgress = 0.0;
      });

      String? finalImageUrl = existingImageUrl;

      try {
        if (imageBytes != null && imageFileName != null) {
          final mimeType = lookupMimeType(imageFileName!);
          await Supabase.instance.client.storage
              .from('product-image')
              .uploadBinary(
                imageFileName!,
                imageBytes!,
                fileOptions: FileOptions(contentType: mimeType ?? 'image/jpeg'),
              );
          finalImageUrl = Supabase.instance.client.storage
              .from('product-image')
              .getPublicUrl(imageFileName!);
        }

        final data = {
          'category': category,
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          'imageUrl': finalImageUrl,
        };

        if (productDoc == null) {
          await _productsCollection.add(data);
        } else {
          await _productsCollection.doc(productDoc.id).update(data);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Operation failed: $e')),
        );
      }

      setState(() {
        isUploading = false;
        uploadProgress = 1.0;
      });
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(productDoc == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(value: 'Pizza', child: Text('Pizza')),
                      DropdownMenuItem(value: 'Beverages', child: Text('Beverages')),
                      DropdownMenuItem(value: 'Burgers', child: Text('Burgers')),
                    ],
                    onChanged: (val) => setStateDialog(() => category = val!),
                  ),
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (val) => name = val,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (val) => description = val,
                    validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    initialValue: price.toString(),
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => price = double.tryParse(val) ?? 0.0,
                    validator: (val) =>
                        val == null || double.tryParse(val) == null ? 'Invalid price' : null,
                  ),
                  TextFormField(
                    initialValue: stock.toString(),
                    decoration: const InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => stock = int.tryParse(val) ?? 0,
                    validator: (val) =>
                        val == null || int.tryParse(val) == null ? 'Invalid stock' : null,
                  ),
                  const SizedBox(height: 10),
                  if (imageBytes != null)
                    Image.memory(imageBytes!, height: 150, fit: BoxFit.cover)
                  else if (existingImageUrl != null && existingImageUrl.isNotEmpty)
                    Image.network(existingImageUrl, height: 150, fit: BoxFit.cover)
                  else
                    const SizedBox(height: 150, child: Center(child: Text('No image selected'))),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        final bytes = await picked.readAsBytes();
                        final fileName =
                            '${DateTime.now().millisecondsSinceEpoch}${path.extension(picked.path)}';
                        setStateDialog(() {
                          imageBytes = bytes;
                          imageFileName = fileName;
                        });
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image'),
                  ),
                  if (isUploading) ...[
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: uploadProgress),
                    const SizedBox(height: 10),
                    const Text('Uploading...'),
                  ]
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate() &&
                          (imageBytes != null || existingImageUrl != null)) {
                        await _uploadAndSaveProduct();
                        Navigator.of(context).pop();
                        setState(() {});
                      } else if (imageBytes == null && existingImageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select an image.')),
                        );
                      }
                    },
              child: Text(productDoc == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProduct(DocumentSnapshot productDoc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _productsCollection.doc(productDoc.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted')),
        );
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddOrEditProductDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No products yet'));
                  }
                  final products = snapshot.data!.docs;
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final productDoc = products[index];
                      final product = productDoc.data() as Map<String, dynamic>;
                      final imageUrl = product['imageUrl'] as String? ?? '';
                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.image_not_supported),
                              ),
                        title: Text(product['name'] ?? 'No Name'),
                        subtitle: Text('${product['category']} • ₱${product['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Stock: ${product['stock']}'),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _showAddOrEditProductDialog(productDoc: productDoc),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteProduct(productDoc),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
