class AddTags
  include ShopifyGraphql::Query

  MUTATION = <<~GRAPHQL
    mutation AddTags($id: ID!, $tags: [String!]!) {
      tagsAdd(id: $id, tags: $tags) {
        node {
          id
        }
        userErrors {
          message
        }
      }
    }
  GRAPHQL

  def call(id:, tags:)
    response = execute(MUTATION, id: id, tags: tags)
    response.data = response.data.tagsAdd
    response
  end
end
