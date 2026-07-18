import 'package:flutter/material.dart';

import '../models/ai_provider_config.dart';

class ProviderSelector extends StatelessWidget {
  const ProviderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AiProvider selected;
  final ValueChanged<AiProvider> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AiProvider>(
      segments: AiProvider.values
          .map(
            (p) => ButtonSegment(
              value: p,
              label: Text(AiProviderConfig.all[p]!.displayName),
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}
