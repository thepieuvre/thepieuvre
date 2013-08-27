package thepieuvre.core

import grails.converters.JSON
import grails.plugins.springsecurity.Secured

@Secured(['ROLE_API'])
class ArticleController {

    private def withArticle(id='id', Closure c) {
        Article article = Article.get(params[id])
        if (article) {
            c.call article
        } else {
            response.status = 404
            def res = [error: true, httpStatus: 404, message: "Article ${params[id]} not found"]
            render res as JSON
        }
    }

    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def modal = {
        log.debug "Getting modal for Article $params.id"
        withArticle { article ->
            render view: 'modal', model: ['article': article]
        }
    }
}
