package thepieuvre.core

enum FeedGlobalEnum {
	GLOBAL,
	PRIVATE,
	NOT_CHECKED

    static FeedGlobalEnum fromString(String global) {
        valueOf(FeedGlobalEnum, global)
    }
}