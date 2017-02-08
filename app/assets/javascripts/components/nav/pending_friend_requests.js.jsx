var PendingFriendRequests = React.createClass({
	getInitialState() {
		return {
			friendRequests: []
		}
	},

	componentDidMount() {
		$.ajax({
			url: `/users/${this.props.userId}/pending_requests.json`,
			type: 'GET',
			dataType: 'JSON',
			context: 'this',
			success: (data) => {
				this.setState({friendRequests: data});				
			}
		})
	},

	handleAcceptRequest(e){
		e.preventDefault();

		var id = $(e.target).data("id");

		$.ajax({
			url: `/users/${id}/request_acceptances`,
			type: 'POST',
			dataType: 'JSON',
			context: 'this',
			success: (data) => {
				var friendRequests = this.state.friendRequests.filter((request) => {
					return request.friendable_id !== id;
				})

				this.setState({friendRequests: friendRequests});

				$('#js-pending-requests-count').text(`(${this.state.friendRequests.length})`);
			}
		})
	},

	handleDeclineRequest(e){
		e.preventDefault();

		var id = $(e.target).data("id");

		$.ajax({
			url: `/users/${id}/request_declinals`,
			type: 'POST',
			dataType: 'JSON',
			context: 'this',
			success: (data) => {
				var friendRequests = this.state.friendRequests.filter((request) => {
					return request.friendable_id != id;
				});
				
				this.setState({friendRequests: friendRequests});

				$('#js-pending-requests-count').text(`(${this.state.friendRequests.length})`);
			}
		})
	},

	requests(){
		var requests = this.state.friendRequests.map((request) => {
			return (
				<li key={request.id} className="request-container">
					<a href={`/users/${request.friendable_id}`} className="request-container-link">
						<div className="user-image-small">
							<img src={request.friendable_photo_url} />
						</div>
						<div className="request-content">
							<div className="display-name">
								{`${request.friendable_last_name} ${request.friendable_first_name}`}
							</div>
							<div className="timestamp">
								{request.created_at}
							</div>
						</div>
					</a>

					<div className="request-actions button-group">
						<button className="button secondary small" data-id={request.friendable_id} onClick={this.handleAcceptRequest}><i className="fi-check"></i> 承認</button>
						<button className="button warning small" data-id={request.friendable_id} onClick={this.handleDeclineRequest}><i className="fi-x-circle"></i> 拒否</button>
					</div>
				</li>
			)
		});

		if (requests.length === 0) {
			requests = <p className="text-center" style={{"marginBottom": "0px"}}>現在友達申請はありません。</p>
		}

		return requests;
	},

	render(){
		return (
			<div>
				{this.requests()}
			</div>
		)
	}
})