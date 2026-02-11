# 📊 STORIES - DIAGRAMMES DE SÉQUENCE
## Flux Techniques Détaillés

---

## 🎬 FLUX 1: VOIR UNE STORY

```mermaid
sequenceDiagram
    participant U as User
    participant UI as StoriesFeedBar
    participant B as StoriesFeedBloc
    participant R as Repository
    participant FS as Firestore
    participant V as StoryViewerPage
    participant VB as StoryViewerBloc

    U->>UI: Ouvre HomePage
    UI->>B: add(LoadStoriesFeed)
    B->>R: getFollowingStories(userId)
    R->>FS: Query users/{userId}/stories_feed
    FS-->>R: Stream<List<StoryModel>>
    R-->>B: Stream<Either<Failure, List<Story>>>
    B->>B: _groupStoriesByUser()
    B-->>UI: emit(StoriesFeedState.success)
    UI-->>U: Affiche cercles stories
    
    U->>UI: Tap sur StoryRing
    UI->>V: Navigator.push(StoryViewerPage)
    V->>VB: add(InitializeStoryViewer)
    VB->>VB: Start segment timer
    VB->>R: recordView(storyId, viewerId)
    R->>FS: Set stories/{id}/viewers/{userId}
    FS->>FS: Trigger onViewerAdded Function
    FS->>FS: Increment viewsCount
    
    VB-->>V: emit(playing segment 0)
    V-->>U: Affiche segment + progress bar
    
    loop Auto-advance segments
        VB->>VB: Timer expires
        VB->>VB: add(NextSegment)
        VB->>R: recordView(segmentIndex + 1)
        VB-->>V: emit(new segment)
    end
    
    U->>V: Tap CTA Button
    V->>VB: add(RecordInteraction)
    VB->>R: recordInteraction(storyId, ctaType)
    R->>FS: Update interactionsCount
    V->>U: Navigate to target (ticket/event/chat)
```

---

## 📤 FLUX 2: CRÉER UNE STORY

```mermaid
sequenceDiagram
    participant U as User
    participant C as StoryCreatorPage
    participant P as ImagePicker
    participant CB as StoryCreatorBloc
    participant R as Repository
    participant DS as DataSource
    participant ST as Storage
    participant FS as Firestore
    participant CF as Cloud Function

    U->>C: Tap "Ajouter Story"
    C->>P: Pick image/video
    P-->>C: List<File>
    C-->>U: Preview segments
    
    U->>C: Add CTA (Optional)
    U->>C: Link event/ticket (Optional)
    U->>C: Tap "Partager"
    
    C->>CB: add(CreateStory)
    CB->>CB: Validate segments
    CB->>R: createStory(params)
    R->>DS: createStory()
    
    loop Upload segments
        DS->>ST: putFile(segment)
        ST-->>DS: downloadUrl
    end
    
    DS->>FS: Create stories/{storyId}
    FS->>FS: Trigger onStoryCreated Function
    
    Note over CF: Cloud Function Fanout
    CF->>FS: Get users/{userId}/followers
    
    loop For each follower
        CF->>FS: Set users/{followerId}/stories_feed/{storyId}
    end
    
    CF-->>FS: Fanout complete
    FS-->>DS: Story created
    DS-->>R: Right(storyId)
    R-->>CB: Success
    CB-->>C: emit(success)
    C-->>U: Show success + navigate home
```

---

## 🔔 FLUX 3: NOTIFICATION PUSH STORY

```mermaid
sequenceDiagram
    participant CF as Cloud Function
    participant FS as Firestore
    participant FCM as Firebase Messaging
    participant U as User Device
    participant APP as BeninExperience App

    Note over CF: Trigger: onStoryCreated
    CF->>FS: Get story data
    CF->>FS: Get followers tokens
    
    loop For each follower
        CF->>CF: Check notification prefs
        CF->>CF: Check rate limit (max 3/day)
        CF->>CF: Check active hours (9h-21h)
        
        alt Should notify
            CF->>FCM: Send notification
            FCM->>U: Push notification
            U->>APP: Tap notification
            APP->>APP: Navigate to StoryViewer
        end
    end
```

---

## 🗑️ FLUX 4: CLEANUP STORIES EXPIRÉES

```mermaid
sequenceDiagram
    participant CS as Cloud Scheduler
    participant CF as cleanupExpiredStories
    participant FS as Firestore
    participant ST as Storage

    CS->>CF: Trigger every 2 hours
    CF->>FS: Query expired stories
    Note over CF: where status='active'<br/>and expiresAt < now
    FS-->>CF: List<Story>
    
    loop For each expired story
        CF->>FS: Update status='expired'
        
        loop For each segment
            CF->>ST: Delete media file
            ST-->>CF: Deleted
        end
    end
    
    CF-->>CS: Complete (log count)
```

---

## 📊 FLUX 5: ANALYTICS STORY (Créateur)

```mermaid
sequenceDiagram
    participant U as Creator
    participant UI as ProfilePage
    participant CF as getStoryAnalytics
    participant FS as Firestore

    U->>UI: Tap "Voir Analytics"
    UI->>CF: Callable Function(storyId)
    CF->>FS: Verify ownership
    
    alt Not owner
        CF-->>UI: Error 403
    else Owner
        CF->>FS: Get story data
        CF->>FS: Get viewers subcollection
        FS-->>CF: List<Viewer>
        
        CF->>CF: Calculate metrics
        Note over CF: completionRate<br/>interactionRate<br/>topExitSegment
        
        CF-->>UI: Analytics data
        UI-->>U: Display dashboard
    end
```

---

## 🎯 FLUX 6: INTERACTION CTA (Acheter Billet)

```mermaid
sequenceDiagram
    participant U as User
    participant V as StoryViewerPage
    participant VB as StoryViewerBloc
    participant R as Repository
    participant FS as Firestore
    participant TP as TicketPage
    participant PS as Payment Service

    U->>V: Tap CTA "Acheter 15,000 FCFA"
    V->>VB: Record interaction
    VB->>R: recordInteraction(ctaType='buy_ticket')
    R->>FS: Increment interactionsCount
    
    V->>TP: Navigate with ticketId
    TP->>FS: Get ticket details
    FS-->>TP: Ticket data
    TP-->>U: Show ticket modal
    
    U->>TP: Select quantity + payment
    TP->>PS: Process payment
    
    alt Payment success
        PS-->>TP: Success
        TP->>FS: Create purchase record
        TP->>FS: Update ticket stock
        TP-->>U: Show confirmation + QR code
    else Payment failed
        PS-->>TP: Error
        TP-->>U: Show error + retry
    end
```

---

## 🔄 FLUX 7: STATES & TRANSITIONS (BLoC)

### **StoriesFeedBloc**
```
[Initial]
   ↓ LoadStoriesFeed
[Loading] ← → [Success]
   ↓              ↑
[Failure]    RefreshFeed
```

### **StoryViewerBloc**
```
[Initial]
   ↓ InitializeStoryViewer
[Playing Segment 0]
   ↓ NextSegment
[Playing Segment 1]
   ↓ PauseSegment
[Paused]
   ↓ PlaySegment
[Playing Segment 1]
   ↓ ... NextSegment
[Completed] → Navigator.pop()
```

---

## 🔐 FLUX 8: SÉCURITÉ & VALIDATION

```mermaid
sequenceDiagram
    participant U as User
    participant APP as App
    participant FR as Firestore Rules
    participant SR as Storage Rules
    participant CF as Cloud Function

    Note over APP: Tentative création story
    APP->>FR: Create stories/{id}
    FR->>FR: Check auth.uid == data.userId
    FR->>FR: Check expiresAt = now + 24h
    FR->>FR: Check segments.length <= 10
    
    alt Valid
        FR-->>APP: Allow write
    else Invalid
        FR-->>APP: Error 403
    end
    
    Note over APP: Upload média
    APP->>SR: Put file stories/{userId}/{mediaId}
    SR->>SR: Check auth.uid == userId
    SR->>SR: Check file size < 100MB
    SR->>SR: Check content type (image/video)
    
    alt Valid
        SR-->>APP: Allow write
    else Invalid
        SR-->>APP: Error 403
    end
    
    Note over CF: Rate limiting
    CF->>CF: Count stories last 24h
    alt < 5 stories
        CF->>CF: Allow create
    else >= 5 stories
        CF-->>APP: Error: Rate limit exceeded
    end
```

---

## 📱 FLUX 9: GESTURES & INTERACTIONS

```
User Actions → StoryViewerBloc Events
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tap Left (x < 33%)      → PreviousSegment
Tap Center (33%-66%)    → [Aucune action]
Tap Right (x > 66%)     → NextSegment
Long Press Start        → PauseSegment
Long Press End          → PlaySegment
Swipe Down              → CompleteStory → Navigator.pop()
Swipe Up (Phase 2)      → ShowDetails
Double Tap (Phase 2)    → LikeStory
Tap CTA Button          → RecordInteraction + Navigate
```

---

## 🔄 FLUX 10: SYNC & CACHE

```mermaid
sequenceDiagram
    participant APP as App
    participant LC as Local Cache
    participant FS as Firestore
    participant NET as Network

    Note over APP: App launch
    APP->>LC: Load cached stories
    LC-->>APP: Display immediately
    
    par Fetch latest from server
        APP->>FS: Stream stories_feed
        FS->>NET: Download new data
        NET-->>FS: Response
        FS-->>APP: Updated stories
    end
    
    APP->>LC: Update cache
    APP->>APP: Merge with displayed
    APP-->>APP: Refresh UI
    
    Note over APP: Offline mode
    APP->>LC: Load cached only
    APP->>APP: Show "Offline" banner
```

---

## 📈 MÉTRIQUES & EVENTS

### **Analytics Events Flow**
```
Story View:
User taps StoryRing
   ↓
StoryViewerBloc.initializeStoryViewer()
   ↓
Analytics.logEvent('story_view', {
  story_id,
  viewer_id,
  source: 'feed' | 'profile' | 'notification'
})
   ↓
Firestore: stories/{id}/viewers/{userId}
   ↓
Cloud Function: onViewerAdded
   ↓
Update viewsCount

CTA Click:
User taps CTA Button
   ↓
Analytics.logEvent('story_cta_click', {
  story_id,
  cta_type,
  target_id
})
   ↓
recordInteraction()
   ↓
Update interactionsCount
```

---

## 🎯 ÉTATS & ERREURS

### **Gestion Erreurs par Layer**

```
UI Layer (Presentation)
   ↓ User action fails
   ↓ Show SnackBar or Dialog
   
BLoC Layer
   ↓ Use case returns Left(Failure)
   ↓ emit(ErrorState(message))
   
Domain Layer
   ↓ Repository returns Failure
   ↓ Either<Failure, Success>
   
Data Layer
   ↓ Datasource throws Exception
   ↓ Catch → ServerException
   ↓ Repository converts to Failure
```

### **Types de Failures**
```dart
abstract class Failure {
  ServerFailure       // Firestore down
  NetworkFailure      // No internet
  CacheFailure        // Local storage error
  ValidationFailure   // Invalid input
  PermissionFailure   // Auth/rules denied
  RateLimitFailure    // Too many requests
  UnexpectedFailure   // Unknown error
}
```

---

✅ **TOUS LES FLUX TECHNIQUES DOCUMENTÉS** 📊
