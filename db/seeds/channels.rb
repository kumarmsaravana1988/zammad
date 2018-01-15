Channel.create_if_not_exists(
  area: 'Email::Notification',
  options: {
    outbound: {
      adapter: 'smtp',
      options: {
        host: 'email-smtp.us-east-1.amazonaws.com',
        user: 'AKIAJ6VVAHGS22AITFFA',
        password: 'AnuGLZKKvhMDNmgHM/X3Wi0NiFXm7BsLEes2i2FpaqlF',
        ssl: true,
        port: 587,
      },
    },
  },
  group_id: 1,
  preferences: { online_service_disable: true },
  active: false,
)
# Channel.create_if_not_exists(
#   area: 'Email::Notification',
#   options: {
#     outbound: {
#       adapter: 'sendmail',
#     },
#   },
#   preferences: { online_service_disable: true },
#   active: true,
# )
