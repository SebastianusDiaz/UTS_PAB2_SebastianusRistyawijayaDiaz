import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uts_pab2_sebastianusristyawijayadiaz/models/gempa_models.dart';
import 'package:uts_pab2_sebastianusristyawijayadiaz/service/gempa_service.dart';

void main() {
  runApp(const GempaApp());
}

class GempaApp extends StatelessWidget {
  const GempaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Info Gempa BMKG',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const GempaScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GempaScreen extends StatelessWidget {
  const GempaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Gempa>(
        future: GempaService.fetchGempa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final gempa = snapshot.data!;
            final imageUrl =
                'https://data.bmkg.go.id/DataMKG/TEWS/${gempa.shakemap}';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset('images/bmkg.jpg', fit: BoxFit.cover),
                        Container(color: Colors.black.withOpacity(0.4)),
                        Positioned(
                          bottom: 20,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Wilayah: ${gempa.wilayah}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Text(
                                "${gempa.tanggal} | ${gempa.jam}",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildHeroShakemap(context, imageUrl),
                        const SizedBox(height: 20),
                        _buildMagnitudeBar(gempa.magnitude),
                        const SizedBox(height: 16),
                        _buildInfoCard(Icons.map, "Lintang", gempa.lintang),
                        _buildInfoCard(
                            Icons.map_outlined, "Bujur", gempa.bujur),
                        _buildInfoCard(
                            Icons.height, "Kedalaman", gempa.kedalaman),
                        _buildInfoCard(Icons.warning, "Potensi", gempa.potensi),
                        _buildInfoCard(
                            Icons.vibration, "Dirasakan", gempa.dirasakan),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return const Center(child: Text('Tidak ada data.'));
          }
        },
      ),
    );
  }

  Widget _buildHeroShakemap(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Peta Guncangan')),
                body: Center(
                  child: Hero(
                    tag: 'shakemap',
                    child: Image.network(imageUrl),
                  ),
                ),
              ),
            ));
      },
      child: Hero(
        tag: 'shakemap',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(imageUrl),
        ),
      ),
    );
  }

  Widget _buildMagnitudeBar(String magnitudeStr) {
    final magnitude = double.tryParse(magnitudeStr) ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Magnitude",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: magnitude / 10,
          minHeight: 14,
          backgroundColor: Colors.grey.shade300,
          color: magnitude >= 6 ? Colors.red : Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 6),
        Text("$magnitude Skala Richter")
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
