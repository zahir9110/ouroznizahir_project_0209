import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/models/event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header animé style Facebook
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Salut, Kevin 👋", style: Theme.of(context).textTheme.bodyMedium),
                Text("Qu'allez-vous découvrir ?", style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
                ),
                onPressed: () {},
              ),
            ],
          ),

          // Barre de recherche (Fake)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4))
                  ]
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textSecondary),
                    SizedBox(width: 10.w),
                    Text("Rechercher un événement...", style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp))
                  ],
                ),
              ),
            ),
          ),

          // Catégories (Scroll Horizontal)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.categories.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == 0;
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Chip(
                        label: Text(MockData.categories[index]),
                        backgroundColor: isSelected ? AppColors.primaryGreen : AppColors.surface,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                        side: BorderSide(color: isSelected ? Colors.transparent : AppColors.divider),
                        shape: const StadiumBorder(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Feed des événements (Cartes)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Event event = MockData.events[index];
                  return _EventCard(event: event);
                },
                childCount: MockData.events.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget réutilisable pour la carte
class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.h),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navigation vers détail
          debugPrint("Click on ${event.title}");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec Badge Prix
            Stack(
              children: [
                Image.network(
                  event.imageUrl,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180.h, color: Colors.grey[300], child: const Icon(Icons.broken_image),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryYellow,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      event.price == 0 ? "Gratuit" : "${event.price} FCFA",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.category, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryGreen)),
                  SizedBox(height: 4.h),
                  Text(event.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Expanded(child: Text(event.location, style: const TextStyle(color: AppColors.textSecondary))),
                      Text(event.date, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  Divider(height: 24.h),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, color: AppColors.primaryRed),
                      SizedBox(width: 4.w),
                      Text("${event.likes}", style: const TextStyle(color: AppColors.textSecondary)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          minimumSize: Size(100.w, 36.h),
                        ),
                        child: const Text("Réserver", style: TextStyle(color: Colors.white)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
