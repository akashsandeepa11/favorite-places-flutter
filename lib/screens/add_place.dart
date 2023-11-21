import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      return;
    }

    ref
        .read(userPlaceProvider.notifier)
        .addPlace(enteredTitle, selectedImage!, selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              maxLength: 50,
              decoration: const InputDecoration(label: Text("Title")),
              controller: _titleController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 12),
            ImageInput(
              onPickImage: (image) {
                setState(() {
                  selectedImage = image;
                });
              },
            ),
            const SizedBox(height: 12),
            LocationInput(onSelectLocation: (location) {
              setState(() {
                selectedLocation = location;
              });
            }),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _titleController.text.isEmpty || selectedImage == null
                  ? null
                  : _savePlace,
              icon: const Icon(Icons.add),
              label: const Text("Add Place"),
            ),
          ],
        ),
      ),
    );
  }
}
