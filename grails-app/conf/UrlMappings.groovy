class UrlMappings {

	static mappings = {
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/member/verification/$token" (controller: 'member', action: 'verification')

		"/api/feed/$id?" (resource: "feed")

		"/"(controller: 'welcome', action:"index") {
			board = "-1"
		}

		"/admin"(view:"/admin")

		"/robots.txt" (view: "/robots")

		"500"(controller: 'error', action: 'internal')
		"400"(controller: 'error', action: 'badRequest')
		"403"(controller: 'error', action: 'accessDenied')
		"404"(controller: 'error', action: 'notFound')
	}
}
