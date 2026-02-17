import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AttachmentPreview extends StatelessWidget {
  const AttachmentPreview({
    super.key,
    required this.pickedImageBytes,
    required this.currentAttachmentBase64,
    required this.currentAttachmentUrl,
    required this.onSelectSource,
    required this.onClearAttachment,
  });

  final Uint8List? pickedImageBytes;
  final String? currentAttachmentBase64;
  final String? currentAttachmentUrl;
  final VoidCallback onSelectSource;
  final VoidCallback onClearAttachment;

  @override
  Widget build(BuildContext context) {
    if (pickedImageBytes != null) {
      return _AttachmentImageMemory(
        bytes: pickedImageBytes!,
        onClear: onClearAttachment,
      );
    }

    final base64Data = _extractBase64(currentAttachmentBase64);
    if (base64Data != null) {
      return _AttachmentImageMemory(
        bytes: base64Data,
        onClear: onClearAttachment,
      );
    }

    if (currentAttachmentUrl != null && currentAttachmentUrl!.isNotEmpty) {
      return _AttachmentImageNetwork(
        url: currentAttachmentUrl!,
        onClear: onClearAttachment,
      );
    }

    return InkWell(
      onTap: onSelectSource,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_enhance, size: 40, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              'Adicionar comprovante/foto',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List? _extractBase64(String? encoded) {
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    final base64String = encoded.contains(',')
        ? encoded.split(',')[1]
        : encoded;

    try {
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }
}

class _AttachmentImageMemory extends StatelessWidget {
  const _AttachmentImageMemory({required this.bytes, required this.onClear});

  final Uint8List bytes;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return _AttachmentContainer(
      onClear: onClear,
      child: Image.memory(bytes, fit: BoxFit.cover),
    );
  }
}

class _AttachmentImageNetwork extends StatelessWidget {
  const _AttachmentImageNetwork({required this.url, required this.onClear});

  final String url;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return _AttachmentContainer(
      onClear: onClear,
      child: Image.network(url, fit: BoxFit.cover),
    );
  }
}

class _AttachmentContainer extends StatelessWidget {
  const _AttachmentContainer({required this.child, required this.onClear});

  final Widget child;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: child,
          ),
        ),
        IconButton(
          onPressed: onClear,
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.close, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
