org_community = Organization.create_if_not_exists(
  id: 1,
  name: 'zionsoftwares',
)
user_community = User.create_or_update(
  id: 2,
  login: 'samuel@zionsoftwares.com',
  firstname: 'Samuel',
  lastname: 'Santhosh',
  email: 'samuel@zionsoftwares.com',
  password: '',
  active: true,
  roles: [ Role.find_by(name: 'Customer') ],
  organization_id: org_community.id,
)

UserInfo.current_user_id = user_community.id

if Ticket.count.zero?
  ticket = Ticket.create!(
    group_id: Group.find_by(name: 'Users').id,
    customer_id: User.find_by(login: 'samuel@zionsoftwares.com').id,
    title: 'Welcome to Zionsoftwares Helpdesk!',
  )
  Ticket::Article.create!(
    ticket_id: ticket.id,
    type_id: Ticket::Article::Type.find_by(name: 'phone').id,
    sender_id: Ticket::Article::Sender.find_by(name: 'Customer').id,
    from: 'Helpdesk Feedback <notifications@colcampus.com>',
    body: 'Welcome!

  Thank you for choosing Zionsoftwares Helpdesk.

  You will find updates and patches at http://zionsoftwares.com. Online
  documentation is available at http://zionsoftwares.com/. Get
  involved (discussions, contributing, ...) at http://zionsoftwares.com/.

  Regards,

  Your Zionsoftwares Helpdesk Team
  ',
    internal: false,
  )
end

UserInfo.current_user_id = 1
