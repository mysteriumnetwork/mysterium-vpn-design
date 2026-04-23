import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../helpers/pump_widget.dart';

const _flag = SizedBox(width: 24, height: 24);

void main() {
  group('ExpandableIpCardHeader', () {
    testWidgets('renders name and subtitle', (tester) async {
      await pumpWidget(
        tester,
        const ExpandableIpCardHeader(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          status: IpCardStatus.idle,
        ),
      );
      expect(find.text('Germany'), findsOneWidget);
      expect(find.text('Frankfurt'), findsOneWidget);
    });

    testWidgets('hides chevron when onChevronTap is null', (tester) async {
      await pumpWidget(
        tester,
        const ExpandableIpCardHeader(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          status: IpCardStatus.idle,
        ),
      );
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('shows chevron and fires onChevronTap', (tester) async {
      var chevronTapped = false;
      await pumpWidget(
        tester,
        ExpandableIpCardHeader(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          status: IpCardStatus.idle,
          onChevronTap: () => chevronTapped = true,
        ),
      );
      await tester.tap(find.byType(IconButton));
      expect(chevronTapped, isTrue);
    });

    testWidgets('fires onContentTap when content area tapped', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        ExpandableIpCardHeader(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          status: IpCardStatus.idle,
          onContentTap: () => tapped = true,
        ),
      );
      await tester.tap(find.text('Germany'));
      expect(tapped, isTrue);
    });
  });

  group('IpCardListItem', () {
    testWidgets('renders name and subtitle and fires onTap', (tester) async {
      var tapped = false;
      await pumpWidget(
        tester,
        IpCardListItem(
          name: 'IP #1',
          subtitle: '203.0.113.5',
          status: IpCardStatus.idle,
          onTap: () => tapped = true,
        ),
      );
      expect(find.text('IP #1'), findsOneWidget);
      expect(find.text('203.0.113.5'), findsOneWidget);
      await tester.tap(find.text('IP #1'));
      expect(tapped, isTrue);
    });

    testWidgets('renders Plus badge when plusUpgrade is true', (tester) async {
      await pumpWidget(
        tester,
        const IpCardListItem(
          name: 'IP',
          subtitle: 'addr',
          status: IpCardStatus.idle,
          plusUpgrade: true,
        ),
      );
      expect(find.text('Plus'), findsOneWidget);
    });
  });

  group('ExpandableIpCard', () {
    testWidgets('renders expanded children when initiallyExpanded is true', (tester) async {
      await pumpWidget(
        tester,
        const ExpandableIpCard(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          initiallyExpanded: true,
          items: [
            IpCardItem(name: 'Child A', subtitle: '1.1.1.1'),
            IpCardItem(name: 'Child B', subtitle: '2.2.2.2'),
          ],
        ),
      );
      expect(find.text('Child A'), findsOneWidget);
      expect(find.text('Child B'), findsOneWidget);
    });

    testWidgets('hides children when collapsed', (tester) async {
      await pumpWidget(
        tester,
        const ExpandableIpCard(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          items: [IpCardItem(name: 'Child A', subtitle: '1.1.1.1')],
        ),
      );
      expect(find.text('Child A'), findsNothing);
    });

    testWidgets('toggles expansion when chevron is tapped (uncontrolled)', (tester) async {
      await pumpWidget(
        tester,
        const ExpandableIpCard(
          name: 'Germany',
          subtitle: 'Frankfurt',
          countryIcon: _flag,
          items: [IpCardItem(name: 'Child A', subtitle: '1.1.1.1')],
        ),
      );
      expect(find.text('Child A'), findsNothing);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(find.text('Child A'), findsOneWidget);
    });
  });
}
