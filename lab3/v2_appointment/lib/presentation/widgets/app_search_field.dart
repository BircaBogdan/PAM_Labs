import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lab3_appointment/core/theme/app_colors.dart';
import 'package:lab3_appointment/core/theme/app_text.dart';

/// Câmpul „Search something” din Figma (327 × 52, rază 15) cu butonul
/// de filtre în dreapta.
///
/// Textul vine din state ([value]); la fiecare tastă se apelează [onChanged].
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.onFilterTap,
    this.activeFilters = 0,
  });

  final String value;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;

  /// Numărul de filtre active – se afișează ca un punct pe iconița de filtre.
  final int activeFilters;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void didUpdateWidget(covariant AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // De ex. după „Clear filters” textul din state devine gol.
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGrey03,
        border: Border.all(color: AppColors.lightGrey02),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              key: const Key('search-field'),
              controller: _controller,
              onChanged: (text) {
                widget.onChanged(text);
                // Reafișăm butonul „x” când textul devine gol / ne-gol.
                setState(() {});
              },
              textInputAction: TextInputAction.search,
              cursorColor: AppColors.coralGreen,
              style: AppText.outfit(size: 14, height: 1.8),
              decoration: InputDecoration.collapsed(
                hintText: widget.hint,
                hintStyle: AppText.outfit(
                  size: 14,
                  color: AppColors.grey01,
                  height: 1.8,
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            _IconTap(
              tooltip: 'Clear',
              onTap: _clear,
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.grey01,
              ),
            ),
          if (widget.onFilterTap != null)
            _IconTap(
              key: const Key('filter-button'),
              tooltip: 'Filter & sort',
              onTap: widget.onFilterTap!,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    'assets/icons/setting.svg',
                    width: 24,
                    height: 24,
                  ),
                  if (widget.activeFilters > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.coralGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightGrey03,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _IconTap extends StatelessWidget {
  const _IconTap({
    super.key,
    required this.tooltip,
    required this.onTap,
    required this.child,
  });

  final String tooltip;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Padding(padding: const EdgeInsets.all(6), child: child),
      ),
    );
  }
}
