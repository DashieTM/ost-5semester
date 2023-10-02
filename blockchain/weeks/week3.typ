#import "../../utils.typ": *

#section("JWT Token")
#columns(
  2,
  [
    #align(
      center,
      [#image("../../Screenshots/2023_10_02_10_55_11.png", width: 100%)],
    )
    #colbreak()
    A jwt token is created with a header, the payload and a secret key, which
    together combines into a hash that will be stored.
  ],
)
#align(
  center,
  [#image("../../Screenshots/2023_10_02_10_56_43.png", width: 80%)],
)

#subsection("Access token and refresh token")
#columns(2, [
  - access has short lifetime -> 20 min etc.
  - access token is used to access content on website -> authentication
  #colbreak()
  - refresh token has long lifetime -> 6 months etc.
  - refresh token is used to generate a new access token easier
])

#section("Load Balancing")
- horizontal scaling -> distribution of workloads
- ensures high availability -> hardware failure might not impact website as load
  balancer will redistribute requests to other servers
- example FOSS load balancer: #link("https://github.com/caddyserver/caddy")[Caddy]
#align(
  center,
  [#image("../../Screenshots/2023_10_02_11_01_30.png", width: 80%)],
)
Example Caddy config//typstfmt::off
```rs
// #Caddyfile
// :7070
// reverse_proxy * {
// to http://dsy-services-1:8080
// to http://dsy-services-2:8080
// to http://dsy-services-3:8080
// to http://dsy-services-4:8080
// to http://dsy-services-5:8080
// }
// lb_policy round_robin
// lb_try_duration 1s
// lb_try_interval 100ms
// fail_duration 10s
// unhealthy_latency 1s
```
//typstfmt::on

#section("CORS Cross Origin Resource Sharing")
- dev solution:
//typstfmt::off
```js
w.Header().Set("Access-Control-Allow-Origin","*")
```
//typstfmt::on
- proper solutions:
  - use reverse proxy
  - allow specific CORS: Access-Control-Allow-Origin: https://foo.example

#section("Containers")
#subsection("OverlayFS")
special filesystem that "merges" two filesystems with one being writeable and one being read-only -> this is useful for ISO bootable sticks with persistent storage or docker containers.

#subsection("Cgroups")
Allows you to split your cpu to different tasks while defining how much of the cpu each task will be allowed to use.
//typstfmt::off
```bash
ls /sys/fs/cgroup
sudo apt install cgroup-tools / yay -S libcgroup
cgcreate -g cpu:red
cgcreate -g cpu:blue
echo -n "20" > /sys/fs/cgroup/blue/cpu.weight
echo -n "80" > /sys/fs/cgroup/red/cpu.weight
cgexec -g cpu:blue bash
cgexec -g cpu:red bash
```
//typstfmt::on

#subsection("Seperate Networks")
Linux network spaces provides isolation for each task:
//typstfmt::off
```bash
ip netns add testnet
ip netns list
#Create virtual ethernet connection
ip link add veth0 type veth peer name veth1 netns testnet
ip link list #?
ip netns exec testnet <cmd>
#Configure network
ip addr add 10.1.1.1/24 dev veth0
ip netns exec testnet ip addr add 10.1.1.2/24 dev veth1
ip netns exec testnet ip link set dev veth1 up
```
//typstfmt::on


