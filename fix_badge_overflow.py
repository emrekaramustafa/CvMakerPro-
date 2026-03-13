path = 'lib/features/paywall/presentation/pages/paywall_page.dart'
with open(path, 'r') as f:
    content = f.read()

# Fix 1: Wrap badge Row children in Flexible to prevent overflow in non-Turkish languages
old = "                        Text(\n                          plan.period,\n                          style: TextStyle(\n                            color: isSelected ? Colors.white : Colors.white70,\n                            fontWeight: FontWeight.w700,\n                            fontSize: 16,\n                          ),\n                        ),\n                        if (plan.badge != null) ...[\n                          const SizedBox(width: 8),\n                          Container("
new = "                        Flexible(\n                          child: Text(\n                            plan.period,\n                            style: TextStyle(\n                              color: isSelected ? Colors.white : Colors.white70,\n                              fontWeight: FontWeight.w700,\n                              fontSize: 16,\n                            ),\n                            overflow: TextOverflow.ellipsis,\n                          ),\n                        ),\n                        if (plan.badge != null) ...[\n                          const SizedBox(width: 6),\n                          Flexible(\n                            child: Container("

if old in content:
    content = content.replace(old, new, 1)
    # Also close the Flexible wrapper after the Container closes
    # Find the closing bracket after Container and add )
    # We need to add a closing ) for the Flexible after the Container's closing ,
    old2 = "                            ),\n                          ),\n                        ],\n                      ],\n                    ),"
    new2 = "                            ),\n                            ),\n                          ),\n                        ],\n                      ],\n                    ),"
    content = content.replace(old2, new2, 1)
    with open(path, 'w') as f:
        f.write(content)
    print('Fixed!')
else:
    print('Pattern not found, showing context:')
    lines = content.split('\n')
    for i, l in enumerate(lines[500:545], 501):
        print(f'{i}: {l}')
