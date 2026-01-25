import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/core/app_spacing.dart';
import 'package:scorelivepro/core/assets_manager.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_lineups.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_header_view.dart';
import 'package:scorelivepro/widget/home/all_matches/widget_match_information.dart';

class HomeLineupsScreen extends StatefulWidget {
  const HomeLineupsScreen({super.key});

  @override
  State<HomeLineupsScreen> createState() => _LineupsScreenState();
}

class _LineupsScreenState extends State<HomeLineupsScreen> {
  @override
  Widget build(BuildContext context) {
    // Sample lineup data for Manchester City
    final manCityPlayers = [
      const Player(number: "31", name: "Ederson", position: "GK"),
      const Player(number: "2", name: "Kyle Walker", position: "RB"),
      const Player(number: "3", name: "Rúben Dias", position: "CB"),
      const Player(number: "6", name: "Nathan Aké", position: "CB"),
      const Player(number: "5", name: "John Stones", position: "LB"),
      const Player(number: "16", name: "Rodri", position: "CM"),
      const Player(number: "17", name: "Kevin De Bruyne", position: "CM"),
      const Player(number: "20", name: "Bernardo Silva", position: "CM"),
      const Player(number: "47", name: "Phil Foden", position: "RW"),
      const Player(number: "9", name: "Erling Haaland", position: "ST"),
      const Player(number: "10", name: "Jack Grealish", position: "LW"),
    ];

    // Sample lineup data for Arsenal
    final arsenalPlayers = [
      const Player(number: "1", name: "Aaron Ramsdale", position: "GK"),
      const Player(number: "4", name: "Ben White", position: "RB"),
      const Player(number: "6", name: "Gabriel Magalhães", position: "CB"),
      const Player(number: "2", name: "William Saliba", position: "CB"),
      const Player(number: "3", name: "Kieran Tierney", position: "LB"),
      const Player(number: "5", name: "Thomas Partey", position: "CM"),
      const Player(number: "8", name: "Martin Ødegaard", position: "CM"),
      const Player(number: "41", name: "Declan Rice", position: "CM"),
      const Player(number: "7", name: "Bukayo Saka", position: "RW"),
      const Player(number: "9", name: "Gabriel Jesus", position: "ST"),
      const Player(number: "11", name: "Gabriel Martinelli", position: "LW"),
    ];

    return Scaffold(
      body: Column(
        children: [
          //Top Match Header Part
          WidgetMatchHeaderView(
            backgroundImage: ImageAssets.home_bg,
            leagueName: 'Match Lineups',
            matchStatus: 'LIVE',
            homeTeamName: 'Bangladesh',
            awayTeamName: 'India',
            score: '3-2',
            onNotificationPressed: () {},
          ),
          //Lineups Body Part
          Expanded(
            child: SingleChildScrollView(
              padding: AppPadding.h16,
              child: Container(
                padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.h12,

                    // Home Team Lineup (Manchester City)
                    TeamLineupCard(
                      teamName: "Manchester City",
                      formation: "4-3-3",
                      players: manCityPlayers,
                    ),

                    AppSpacing.h32,

                    // Away Team Lineup (Arsenal)
                    TeamLineupCard(
                      teamName: "Arsenal",
                      formation: "4-3-3",
                      players: arsenalPlayers,
                    ),

                    AppSpacing.h24,

                    // Match Information
                    WidgetMatchInformation(
                      stadium: "Etihad Stadium",
                      referee: "Farhan Shahriar",
                    ),

                    AppSpacing.h16,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
