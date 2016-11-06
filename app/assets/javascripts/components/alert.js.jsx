var FormAlert = React.createClass({
    getInitialState: function() {
        return {message: this.props.message}
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({message: nextProps.message})

        //alert('sup: '+ (nextProps.message != undefined));
        $('.alert').css('display', 'none');
        if(nextProps.message != undefined) {
         //   alert('again');
        

        setTimeout(function(){
            $('.alert').show();
        },300); 

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
