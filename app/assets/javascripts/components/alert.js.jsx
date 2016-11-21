var FormAlert = React.createClass({
    getInitialState: function() {
        return {message: this.props.message}
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({message: nextProps.message});
 
    },
    render: function() {

        $('.alert').css('display', 'none');
        if(this.props.message != undefined && this.props.message != '') {       

            setTimeout(function(){
       
                $('.alert').show().delay(2000).hide(100);
                
            },300); 

        }

        return (
            <div className="alert alert-success" role="alert" style={{'display': 'none'}}>
              {this.state.message}
            </div>
        )
    }
})
