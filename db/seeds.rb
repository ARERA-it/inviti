users = [
  {
    display_name: "Marco Rossi",
    username: "marcorossi",
    email: "marcorossi@example.it",
    job_title: "Presidente",
    appointeeable: true,
    role: :president
  },
  {
    display_name: "Laura Pistacchi",
    username: "laurapistacchi",
    email: "laurapistacchi@example.it",
    job_title: "Commissario",
    appointeeable: true,
    role: :commissary
  },
  {
    display_name: "Simone Fragola",
    username: "simonefragola",
    email: "simonefragola@example.it",
    job_title: "Commissario",
    appointeeable: true,
    role: :commissary
  },
  {
    display_name: "Anastasia Lampone",
    username: "anastasialamone",
    email: "anastasialamone@example.it",
    job_title: "Commissario",
    appointeeable: true,
    role: :commissary
  },
  {
    display_name: "Giancarlo Capperi",
    username: "giancarlocapperi",
    email: "giancarlocapperi@example.it",
    job_title: "Commissario",
    appointeeable: true,
    role: :commissary
  },
  {
    display_name: "Carolina Mela",
    username: "carolinamela",
    email: "carolinamela@example.it",
    appointeeable: true,
    job_title: "Segretario Generale",
    role: :advisor
  },
  {
    display_name: "Hans Kruger",
    username: "hanskruger",
    email: "hanskruger@example.it",
    job_title: "Web Developer",
    role: :admin
  }
].each do |u|
  User.find_or_create_by(email: u[:email]) do |user|
    user.username      = u[:email]
    user.display_name  = u[:display_name]
    user.job_title     = u[:job_title]
    user.role          = u[:role]
    user.appointeeable = u.fetch(:appointeeable){ false }
    user.initials      = User.calc_initials(u[:display_name])
  end
end
