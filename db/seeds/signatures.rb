Signature.create_if_not_exists(
  id: 1,
  name: 'default',
  body: '
  #{user.firstname} #{user.lastname}

--
Zionsoftwares Helpdesk
Email: samuel@zionsoftwares.com - Web: http://www.zionsoftwares.com/
--'.text2html,
  updated_by_id: 1,
  created_by_id: 1
)
