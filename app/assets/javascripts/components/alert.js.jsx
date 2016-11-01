var FormAlert = React.createClass({
    getInitialState: function() {
        return {message: this.props.message}
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({message: nextProps.message})
        if(nextProps.message != undefined) {

        $('.alert').show();
        }
    },
    render: function() {
        return (
            <div className="alert alert-success" role="alert" style={{'display': 'none'}}>
              {this.state.message}
            </div>
        )
    }
})
