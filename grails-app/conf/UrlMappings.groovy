class UrlMappings {

	static mappings = {
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/api/feed/$id?" (resource: "feed")

		"/"(view:"/index")

		"500"(controller: 'error', action: 'internal')
		"400"(controller: 'error', action: 'badRequest')
		"403"(controller: 'error', action: 'accessDenied')
		"404"(controller: 'error', action: 'notFound')
	}
}
