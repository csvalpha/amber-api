class CoffeeController < ApplicationController
  after_action :verify_authorized, except: :index

  TEAPOT_IMAGE = '
                       (
            _           ) )
         _,(_)._        ((
    ___,(_______).        )
  ,\'__.   /       \    /\_
 /,\' /  |""|       \  /  /
| | |   |__|       |,\'  /
 \`.|                  /
  `. :           :    /
    `.            :.,\'
      `-.________,-\'
  '.freeze

  def index
    render json: { errors: [json_error] }, status: 418
  end

  private

  def json_error
    {
      code: 418,
      detail: 'I\'m a teapot',
      links: {
        about: 'https://tools.ietf.org/html/rfc7168#section-2.3.3'
      },
      meta: {
        image: TEAPOT_IMAGE
      }
    }
  end
end
