# 🚀 ROADMAP BŌKEN B2B2C

## Vue d'ensemble

Cette roadmap détaille l'implémentation de Bōken en tant que plateforme B2B2C où les organisateurs sont les vrais clients.

---

## Phase 1: Foundation (4 semaines)

### Sprint 1-2: Backend Core (2 semaines)

#### Week 1: Setup & Auth
- [x] Repository Git structuré
- [ ] Setup NestJS project
- [ ] PostgreSQL database setup
- [ ] Database migrations (Prisma/TypeORM)
- [ ] Firebase Auth integration
- [ ] JWT token system
- [ ] User registration endpoint
- [ ] Login/logout endpoints
- [ ] Password reset flow

#### Week 2: User Management
- [ ] User profile CRUD
- [ ] User type management (traveler/organizer/admin)
- [ ] Organizer registration flow
- [ ] Verification document upload
- [ ] Admin verification panel (basic)
- [ ] Email notifications (SendGrid/Brevo)
- [ ] Phone verification (optional)

**Livrables Sprint 1-2:**
- ✅ Backend API fonctionnel
- ✅ Auth system complet
- ✅ User & Organizer models
- ✅ Database schema v1

---

### Sprint 3-4: Flutter Foundation (2 semaines)

#### Week 3: App Setup & Auth UI
- [ ] Clean Architecture structure
- [ ] GetIt service locator setup
- [ ] API client (Dio + interceptors)
- [ ] Login page design
- [ ] Register page design
- [ ] Password reset page
- [ ] Auth BLoC/State management
- [ ] Token persistence (flutter_secure_storage)
- [ ] Auto-login on app start

#### Week 4: Profile & Navigation
- [ ] Main navigation (bottom nav)
- [ ] Profile page (traveler)
- [ ] Edit profile page
- [ ] Become organizer page
- [ ] Organizer verification form
- [ ] Image picker for documents
- [ ] Loading states & error handling
- [ ] Responsive design (ScreenUtil)

**Livrables Sprint 3-4:**
- ✅ App avec auth fonctionnel
- ✅ Navigation principale
- ✅ Profils utilisateurs
- ✅ Flow "become organizer"

---

## Phase 2: Core Features (6 semaines)

### Sprint 5-6: Offers Management (2 semaines)

#### Week 5: Backend Offers
- [ ] Offers table & model
- [ ] Create offer endpoint
- [ ] Get offers (list + filters)
- [ ] Update offer endpoint
- [ ] Delete offer endpoint
- [ ] Offer categories handling
- [ ] Media upload (Firebase Storage)
- [ ] Location geocoding
- [ ] Offer validation rules

#### Week 6: Flutter Offers
- [ ] Create offer page
- [ ] Category selector widget
- [ ] Offer form (multi-step)
- [ ] Image picker & upload
- [ ] Location picker (map)
- [ ] Date/time pickers
- [ ] Offer list page (organizer)
- [ ] Offer detail page
- [ ] Edit offer flow

**Livrables Sprint 5-6:**
- ✅ Organisateurs peuvent créer offres
- ✅ Gestion complète des offres
- ✅ Upload d'images
- ✅ Catégories multiples

---

### Sprint 7-8: Feed & Discovery (2 semaines)

#### Week 7: Backend Feed
- [ ] Feed algorithm (basic)
- [ ] Explore by location endpoint
- [ ] Trending offers endpoint
- [ ] Like/unlike offer
- [ ] Save/unsaved offer
- [ ] Offer views tracking
- [ ] Search offers (Algolia/PostgreSQL FTS)
- [ ] Filter & sort options

#### Week 8: Flutter Feed
- [ ] Feed page (InfiniteScroll)
- [ ] Offer card component
- [ ] Like/save buttons
- [ ] Explore page
- [ ] Search page
- [ ] Filters bottom sheet
- [ ] Organizer profile public view
- [ ] Badge display

**Livrables Sprint 7-8:**
- ✅ Feed fonctionnel
- ✅ Discovery des offres
- ✅ Interactions (like/save)
- ✅ Profils organisateurs publics

---

### Sprint 9-10: Bookings System (2 semaines)

#### Week 9: Backend Bookings
- [ ] Bookings table & model
- [ ] Create booking endpoint
- [ ] Booking validation (capacity check)
- [ ] Booking code generation
- [ ] QR code generation
- [ ] Booking status management
- [ ] Cancel booking endpoint
- [ ] Confirm booking endpoint
- [ ] My bookings endpoint (traveler)
- [ ] My bookings endpoint (organizer)

#### Week 10: Flutter Bookings
- [ ] Booking page (quantity, dates)
- [ ] Booking form validation
- [ ] Booking confirmation page
- [ ] My bookings page (traveler)
- [ ] Booking detail page
- [ ] QR code display
- [ ] Cancel booking flow
- [ ] Booking status badge
- [ ] Notifications (booking created)

**Livrables Sprint 9-10:**
- ✅ Système de réservation complet
- ✅ QR codes tickets
- ✅ Gestion bookings
- ✅ Notifications

---

## Phase 3: Monetization (4 semaines)

### Sprint 11-12: Payment Integration (2 semaines)

#### Week 11: Backend Payments
- [ ] Payment service (Mobile Money)
- [ ] Payment initialization
- [ ] Payment webhook handling
- [ ] Transaction tracking
- [ ] Commission calculation
- [ ] Organizer payout calculation
- [ ] Stripe integration (cards)
- [ ] Refund system
- [ ] Payment status updates

#### Week 12: Flutter Payments
- [ ] Payment page
- [ ] Payment method selector
- [ ] Mobile Money flow (MTN/Moov)
- [ ] Card payment flow (Stripe)
- [ ] Payment success page
- [ ] Payment failed page
- [ ] Transaction history
- [ ] Payment status tracking

**Livrables Sprint 11-12:**
- ✅ Paiements Mobile Money
- ✅ Paiements cartes (Stripe)
- ✅ Commission tracking
- ✅ Transactions sécurisées

---

### Sprint 13-14: Organizer Dashboard (2 semaines)

#### Week 13: Backend Analytics
- [ ] Dashboard stats endpoint
- [ ] Revenue tracking
- [ ] Bookings analytics
- [ ] Offer performance
- [ ] Geographic breakdown
- [ ] Payout history endpoint
- [ ] Earnings calculation
- [ ] Export data (CSV/PDF)

#### Week 14: Flutter Dashboard
- [ ] Dashboard home page
- [ ] Revenue chart
- [ ] Bookings list
- [ ] Analytics page
- [ ] Earnings page
- [ ] Payout history page
- [ ] Stat cards widgets
- [ ] Performance charts
- [ ] Export reports button

**Livrables Sprint 13-14:**
- ✅ Dashboard organisateur complet
- ✅ Statistiques temps réel
- ✅ Revenus & payouts
- ✅ Performance tracking

---

## Phase 4: Growth Features (4 semaines)

### Sprint 15-16: Reviews & Ratings (2 semaines)

#### Week 15: Backend Reviews
- [ ] Reviews table & model
- [ ] Create review endpoint
- [ ] Get reviews (offer/organizer)
- [ ] Update review
- [ ] Delete review
- [ ] Rating calculation
- [ ] Review moderation
- [ ] Verified review badge

#### Week 16: Flutter Reviews
- [ ] Review page (after booking)
- [ ] Rating stars widget
- [ ] Photo upload (review)
- [ ] Reviews list page
- [ ] Review card component
- [ ] Average rating display
- [ ] Filter reviews
- [ ] Report review

**Livrables Sprint 15-16:**
- ✅ Système d'avis complet
- ✅ Notes organisateurs
- ✅ Reviews avec photos
- ✅ Modération

---

### Sprint 17-18: Boost & Premium (2 semaines)

#### Week 17: Backend Boost
- [ ] Boost campaigns table
- [ ] Create boost endpoint
- [ ] Boost payment
- [ ] Campaign management
- [ ] Impressions tracking
- [ ] Clicks tracking
- [ ] Conversions tracking
- [ ] Boost expiration
- [ ] Featured offers in feed

#### Week 18: Flutter Boost
- [ ] Boost offer page
- [ ] Campaign type selector
- [ ] Budget & duration picker
- [ ] Boost payment
- [ ] Active campaigns page
- [ ] Campaign analytics
- [ ] Pause/resume campaign
- [ ] Boost stats widget

**Livrables Sprint 17-18:**
- ✅ Système de boost
- ✅ Visibilité premium
- ✅ Analytics campagnes
- ✅ Paiement boost

---

## Phase 5: Polish & Launch (4 semaines)

### Sprint 19-20: Admin & Tools (2 semaines)

#### Week 19: Admin Panel
- [ ] Admin dashboard (Retool/Custom)
- [ ] Verify organizers
- [ ] Moderate content
- [ ] Manage payouts
- [ ] User management
- [ ] Analytics global
- [ ] Reports & exports
- [ ] Support tickets

#### Week 20: DevOps & Infra
- [ ] Production deployment (Railway/Render)
- [ ] Database backups
- [ ] CDN setup (CloudFlare)
- [ ] Monitoring (Sentry)
- [ ] Logging (Better Stack)
- [ ] CI/CD pipeline
- [ ] Load testing
- [ ] Security audit

**Livrables Sprint 19-20:**
- ✅ Admin panel fonctionnel
- ✅ Infrastructure production
- ✅ Monitoring actif
- ✅ Sécurité validée

---

### Sprint 21-22: Testing & Launch (2 semaines)

#### Week 21: Testing
- [ ] Unit tests (backend)
- [ ] Integration tests (API)
- [ ] Widget tests (Flutter)
- [ ] E2E tests (key flows)
- [ ] Performance testing
- [ ] Security testing
- [ ] Beta testing (50 users)
- [ ] Bug fixes

#### Week 22: Launch
- [ ] App Store submission (iOS)
- [ ] Play Store submission (Android)
- [ ] Landing page
- [ ] Documentation
- [ ] Onboarding tutorials
- [ ] Support email setup
- [ ] Marketing assets
- [ ] Soft launch

**Livrables Sprint 21-22:**
- ✅ Apps sur stores
- ✅ Tests complets
- ✅ Documentation
- ✅ Beta launch

---

## Post-Launch (Ongoing)

### Maintenance & Growth
- [ ] User feedback monitoring
- [ ] Performance optimization
- [ ] Feature requests tracking
- [ ] A/B testing
- [ ] Marketing campaigns
- [ ] Partnership BD
- [ ] Scale infrastructure
- [ ] International expansion

### Features V2 (Backlog)
- [ ] Stories (like Instagram)
- [ ] In-app chat
- [ ] Video content
- [ ] Live events
- [ ] Loyalty program
- [ ] Referral system
- [ ] API for partners
- [ ] White label solution

---

## Metrics to Track

### Growth Metrics
- DAU/MAU
- New signups (travelers vs organizers)
- Retention rate (D1, D7, D30)
- Churn rate

### Business Metrics
- GMV (Gross Merchandise Value)
- Commission revenue
- Boost revenue
- Average booking value
- Conversion rate (view → booking)

### Engagement Metrics
- Time in app
- Offers viewed per session
- Bookings per traveler
- Repeat booking rate
- Review completion rate

### Organizer Metrics
- Active organizers
- Offers published per organizer
- Bookings per offer
- Average organizer revenue
- Payout frequency

---

**Durée totale estimée**: 22 semaines (5.5 mois)  
**Team size recommandé**: 
- 1 Backend dev (NestJS)
- 1 Flutter dev
- 1 Product/Design
- 1 DevOps (part-time)

**Version maintenue par**: Kevin Houndeton  
**Dernière mise à jour**: 10 février 2026
