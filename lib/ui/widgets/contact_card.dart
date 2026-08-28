import 'package:crud_api_implementation/models/contact_model.dart';
import 'package:crud_api_implementation/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatefulWidget {
  final Contact contact;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ContactCard({
    Key? key,
    required this.contact,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  static bool _hasPlayedIntro = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: Offset.zero,
          end: const Offset(-0.2, 0),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween(const Offset(-0.2, 0)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: Offset.zero,
          end: const Offset(0.2, 0),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween(const Offset(0.2, 0)), weight: 10),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_controller);

    if (widget.index == 0 && !_hasPlayedIntro) {
      _hasPlayedIntro = true;
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.contact.id.toString()),
      direction: DismissDirection.horizontal,
      background: _buildActionBackground(
        color: AppColors.editAction,
        icon: Icons.edit,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
      ),
      secondaryBackground: _buildActionBackground(
        color: AppColors.errorAndAction,
        icon: Icons.delete,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          widget.onDelete();
          return false;
        } else if (direction == DismissDirection.startToEnd) {
          widget.onEdit();
          return false;
        }
        return false;
      },
      child: Stack(
        children: [
          if (widget.index == 0)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: AppColors.editAction,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.errorAndAction,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SlideTransition(
            position: _slideAnimation,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              color: AppColors.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contact.name ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInfoRow(
                            Icons.phone,
                            widget.contact.phone ?? 'N/A',
                          ),
                          const SizedBox(height: 4),
                          _buildInfoRow(
                            Icons.home,
                            widget.contact.address ?? 'N/A',
                          ),
                          const SizedBox(height: 4),
                          _buildInfoRow(
                            Icons.family_restroom,
                            "Father: ${widget.contact.fathersName ?? 'N/A'}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBackground({
    required Color color,
    required IconData icon,
    required Alignment alignment,
    required EdgeInsets padding,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: alignment,
      padding: padding,
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
