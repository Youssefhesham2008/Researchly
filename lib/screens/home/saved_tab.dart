import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/paper_provider.dart';
import '../../widgets/paper_card.dart';

class SavedTab extends StatelessWidget {
  const SavedTab({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PaperProvider>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: prov.savedPapers.isEmpty
          ? Center(child: Text('no_papers'.tr()))
          : ListView.separated(
        itemCount: prov.savedPapers.length,
        itemBuilder: (_, i) => PaperCard(
          paper: prov.savedPapers[i],
          showImage: false, // في المحفوظات هنخليها بدون صور
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    );
  }
}


