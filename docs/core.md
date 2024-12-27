# AIO Core API

The AIO Core API is a set of functions / classes allowing you to easily start and manage different aspects of your AIO application.

## Package Dependencies

- `path_provider` - Used in the Logger to save logs to a file.
- `shared_preferences` - AIO provides a complementary API to the shared_preferences package.
- `go_router` - AIO provides a way of initializing GoRouter.
- `flutter_secure_storage` - AIO provides a secure session handler.

## Built-ins

### Application Dependencies

#### What are application dependencies ?

Application dependencies are built-ins classes that can be initialized if needed with the app's startup.

- [Prefs](dependencies/prefs.md)
- [GoRouter](dependencies/go_router.md)

Built-ins dependencies are accesible through `App` instance:`App().prefs`

Your custom dependencies will be accesible using: `App().use<MyDependency>()`

#### How to create my dependency ?

WIP

### Extensions

#### What are extensions ?

Extensions are added the core class: `App`. They are adding functionalities to your app and are accessible through variable of the same name.

**Note some of them depends on [Application Dependencies](#Application-Dependencies).**

- [Locale](extensions/locale.md)
- [Session](extensions/session.md)
