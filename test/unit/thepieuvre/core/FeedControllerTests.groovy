package thepieuvre.core

import grails.test.mixin.Mock
import grails.test.mixin.TestFor

@TestFor(FeedController)
@Mock([Feed, FeedService])
class FeedControllerTests {

	void testSave() {
		request.method = 'POST'
		params.link = 'http://some.feedurl.com/rss'
		controller.save()
		assert response.status == 200
		assert Feed.getAll().size() == 1
	}

	void testUpdate() {
		request.method = 'UPDATE'
		Feed feed = new Feed(link: 'http://www.toto.com')
		feed.save()
		params.id = feed.id
		params.comment = 'a comment'
		params.link = 'http://www.titi.com'
		controller.update()
		assert response.status == 200
		assert feed.comment == 'a comment'
		assert feed.link == 'http://www.titi.com'
	}

	void testUpdateNotFound() {
		request.method = 'UPDATE'
		params.id = '69'
		controller.update()
		assert response.status == 404
		assert response.json.message == 'Feed 69 not found'
	}

	void testShow() {
		request.method = 'GET'
		Feed feed = new Feed(link: 'http://www.toto.com')
		feed.save()
		params.id = feed.id
		controller.show()
		assert response.status == 200
	}

	void testShowNotFound() {
		request.method = 'GET'
		params.id = '69'
		controller.show()
		assert response.status == 404
		assert response.json.message == 'Feed 69 not found'
	}

	void testDelete() {
		request.method = 'DELETE'
		Feed feed = new Feed(link: 'http://www.toto.com')
		feed.save()
		params.id = feed.id
		controller.delete()
		assert response.status == 200
		assert feed.active == false
	}

	void testDeleteNotFound() {
		request.method = 'DELETE'
		params.id = '69'
		controller.delete()
		assert response.status == 404
		assert response.json.message == 'Feed 69 not found'
	}

}