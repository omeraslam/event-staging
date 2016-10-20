var EditorPanel = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event: this.props.event

        }
    },
    componentWillReceiveProps: function(nextProps) {
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },




    render: function() {
        return (
            <div className="editor-panel">
            
                <TicketForm current_selection={this.state.current_selection} event={this.state.event}/>
            </div>
        )
   } 



});

