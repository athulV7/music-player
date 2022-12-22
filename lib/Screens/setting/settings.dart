import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:melomusic/Screens/setting/privacy_policy.dart';
import 'package:melomusic/Screens/setting/terms_conditions.dart';
import 'package:share/share.dart';
import '../../database/playlist_db.dart';
import '../widget/music_store.dart';
import 'about_us.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade300,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: const Color.fromARGB(255, 113, 68, 236),
                  ),
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.20,
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadiusDirectional.circular(16),
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/IMG_20221218_.jpg',
                                  ),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          'MeloMusic',
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.01,
                        ),
                        Text(
                          'Version 1.0',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const AboutUs();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        'About Us',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Share.share(
                            'https.//play.google.com/store/apps/details?id=com.');
                      },
                      icon: const Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Share App',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const TermsNconditions();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.list_alt,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Terms & conditions',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const PrivacyPolicy();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Privacy Policy',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        MusicStore.player.stop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Reset App',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              content: const Text(
                                'Are you sure want to reset this application?',
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 113, 68, 236),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                  child: const Text(
                                    'No',
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 113, 68, 236),
                                  ),
                                  onPressed: () {
                                    PlaylistDB.appReset(context);
                                  },
                                  child: const Text(
                                    'Yes',
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.settings_backup_restore,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Reset App',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
