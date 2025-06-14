import 'package:flutter/material.dart';
import 'package:astral/k/app_s/aps.dart';

// 房间设置弹窗组件
class RoomSettingsSheet extends StatefulWidget {
  const RoomSettingsSheet({Key? key}) : super(key: key);

  @override
  State<RoomSettingsSheet> createState() => _RoomSettingsSheetState();

  static Future<void> show(BuildContext context) async {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    if (isDesktop) {
      // PC端显示为对话框
      return showDialog(
        context: context,
        builder:
            (_) => Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                  maxHeight: 600,
                ),
                child: const RoomSettingsSheet(),
              ),
            ),
      );
    }

    // 移动端显示为底部弹窗
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder:
                (_, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: const RoomSettingsSheet(),
                ),
          ),
    );
  }
}

class _RoomSettingsSheetState extends State<RoomSettingsSheet> {
  // 构建设置项标题
  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  // 构建设置项组件
  Widget _buildSettingSection(
    String title,
    List<Widget> buttons,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, colorScheme),
        Wrap(spacing: 8, runSpacing: 8, children: buttons),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // 标题栏
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart_outlined,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '房间设置',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '点击下方设置项进行配置，所有更改将实时生效',
                textAlign: TextAlign.left,
                maxLines: null,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // 滚动内容区域
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // 显示模式
              _buildSettingSection('显示模式', [
                _buildOptionButton(
                  '简约',
                  Aps().userListSimple.watch(context),
                  () {
                    Aps().setUserListSimple(true);
                  },
                ),
                _buildOptionButton(
                  '详细',
                  !Aps().userListSimple.watch(context),
                  () {
                    Aps().setUserListSimple(false);
                  },
                ),
              ], colorScheme),

              // 用户显示
              _buildSettingSection('用户显示', [
                _buildOptionButton(
                  '默认',
                  Aps().displayMode.watch(context) == 0,
                  () => Aps().setDisplayMode(0),
                ),
                _buildOptionButton(
                  '用户',
                  Aps().displayMode.watch(context) == 1,
                  () => Aps().setDisplayMode(1),
                ),
                _buildOptionButton(
                  '服务器',
                  Aps().displayMode.watch(context) == 2,
                  () => Aps().setDisplayMode(2),
                ),
              ], colorScheme),

              // 用户排序
              _buildSettingSection('用户排序', [
                _buildOptionButton(
                  '默认',
                  Aps().sortOption.watch(context) == 0,
                  () => Aps().setSortOption(0),
                ),
                _buildOptionButton(
                  '延迟',
                  Aps().sortOption.watch(context) == 1,
                  () => Aps().setSortOption(1),
                ),
                _buildOptionButton(
                  '用户名',
                  Aps().sortOption.watch(context) == 2,
                  () => Aps().setSortOption(2),
                ),
              ], colorScheme),

              // 排序方式
              _buildSettingSection('排序方式', [
                _buildOptionButton(
                  '升序',
                  Aps().sortOrder.watch(context) == 0,
                  () => Aps().setSortOrder(0),
                ),
                _buildOptionButton(
                  '降序',
                  Aps().sortOrder.watch(context) == 1,
                  () => Aps().setSortOrder(1),
                ),
              ], colorScheme),
            ],
          ),
        ),
      ],
    );
  }

  // 构建选项按钮
  Widget _buildOptionButton(
    String text,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return IntrinsicWidth(
      child: SizedBox(
        height: 32,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            backgroundColor:
                isSelected ? colorScheme.primary : colorScheme.surfaceVariant,
            foregroundColor:
                isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
            side: BorderSide(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(text, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}
