 package challenge_1


import "core:fmt"
import n "core:net"
import "core:bytes"
import "core:log"




main :: proc() {

	ipv4 := n.Address_Family.IP4
	tcp := n.Socket_Protocol.TCP

	//create socket 
	socket, err := n.create_socket(ipv4, tcp) 

	//handle error
	if err != nil {
		fmt.println("error creating socket")
		return
	}

	endpoint , endpoint_parse_ok := n.parse_endpoint("127.0.0.1:80")


	if ! endpoint_parse_ok {

			log.errorf("failed to parse endpoint")

	}

	defer n.close(socket)

	err = n.bind(socket,endpoint)

	if err != nil {
		fmt.println("error binding socket")
		return
	}

	fmt.println("Server is listening on port:",endpoint) 



	listen_socket, err_2 := n.listen_tcp(endpoint)

	if err_2 != nil {
		fmt.println("error  starting server")
		return
	}



	b: bytes.Buffer
	bytes.buffer_init_allocator(&b,0,2048)
	bytes.buffer_write_string(&b, "HTTP/1.1 200 OK\r\n")


	welcome_message := bytes.buffer_to_bytes(&b)

	for {

		client_socket, _, accept_error := n.accept_tcp(listen_socket)

		if accept_error != nil {

			log.errorf("failed to accept connection:", accept_error)

			continue
		}


		i := 0
		for i < len(welcome_message) {
			n, send_error := n.send_tcp(client_socket,welcome_message)
			if send_error != nil {
			log.errorf("failed to accept connection:", send_error) 

				break

			}
			i += n

		}

	}


	


}
