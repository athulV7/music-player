import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const SizedBox(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '''Welcome to Melomusic, your number one source for music . We're dedicated to providing you the very best quality of sound and the music varient, with an emphasis on new features,playlists and favourites, and a rich user experience.
      
            Founded in 2022 by Athul V, Music App is our first major project with a basic performance of music hub and creates a better version in future. Music gives you the best music experience that you never had. It includes attractive mode of UI’s and good practices.
            
            It gives good quality and had increased the settings to power up the system as well as  to provide better  music rythms.
            
            We hope you enjoy our music as much as we enjoy offering them to you. If you have any questions or comments, please don't hesitate to contact us.
            
            Sincerely,
            
            
            Athul V''',
                  style:
                      TextStyle(color: Colors.black, height: 2, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
